const express = require("express");
const bodyParser = require("body-parser");
const jwt = require("jsonwebtoken");
const PocketBase = require("pocketbase/cjs");
const timeout = require("connect-timeout");
const http = require("http");

const pb = new PocketBase("http://127.0.0.1:8090");
const SECRET_KEY = "your_secret_key";

const app = express();

app.use(bodyParser.json());
app.use(timeout("60s"));
app.use(haltOnTimedOut);

const server = http.createServer(app);

// Adjust timeout settings
server.keepAliveTimeout = 60000; // 60 seconds
server.headersTimeout = 60000; //
function haltOnTimedOut(req, res, next) {
  if (!req.timedout) next();
}

function authenticateToken(req, res, next) {
  const token = req.headers["authorization"]?.split(" ")[1];
  if (!token) return res.status(401).send("Access Denied");

  jwt.verify(token, SECRET_KEY, (err, user) => {
    if (err) return res.status(403).send("Invalid Token");
    req.user = user;
    next();
  });
}

app.post("/login", async (req, res) => {
  const { username, password } = req.body;

  try {
    const authResponse = await pb
      .collection("users")
      .authWithPassword(username, password);
    const user = authResponse.record;

    const location = await pb.collection("branches").getOne(user.location);
    const role = await pb.collection("roles").getOne(user.role);
    const department = await pb
      .collection("departments")
      .getOne(user.department);

    let manager = null;

    if (user.reports_to) {
      managerProfile = await pb.collection("users").getOne(user.reports_to);
      manager = {
        name: managerProfile.name,
        surname: managerProfile.surname,
        id: managerProfile.id,
      };
    }

    const jwtToken = jwt.sign(
      {
        id: user.id,
        role: role.employee_role,
        manager: manager != null ? manager.id : null,
      },
      SECRET_KEY,
      {
        expiresIn: "1h",
      }
    );

    res.json({
      token: jwtToken,
      user: {
        id: user.id,
        name: user.name,
        surname: user.surname,
        username: user.username,
        email: user.email,
        role: role.employee_role,
        department: department.work_department,
        location: location.location,
        manager: manager,
        annual_leave_balance: user.annual_leave_balance,
        family_leave_balance: user.family_leave_balance,
        sick_leave_balance: user.sick_leave_balance,
      },
    });
  } catch (error) {
    console.log(error);
    res.status(401).send("Invalid credentials");
  }
});

// Submit a leave request
app.post("/leave-request", authenticateToken, async (req, res) => {
  const { leave_type, days, reason, duration, start_date, end_date } = req.body;
  try {
    let leaveTypeId = null;
    switch (leave_type) {
      case "Annual Leave":
        leaveTypeId = "4otbfoud3pzsmxj";
        break;
      case "Family Responsibility Leave":
        leaveTypeId = "0lwmb9i6yfpm8ie";
        break;
      case "Sick Leave":
        leaveTypeId = "6myfo52dc2ugybl";
        break;
      default:
        leave_type = null;
    }

    await pb.collection("leave_requests").create({
      employee: req.user.id,
      leave_type: leaveTypeId,
      manager: req.user.manager,
      start_date,
      end_date,
      reason,
      duration,
      status: "Pending",
    });
    res.status(201).send("Leave request submitted");
  } catch (error) {
    console.log(error);
    res.status(500).send("Failed to submit leave request");
  }
});

// Get leave requests for employees or admins
app.get("/leave-requests", authenticateToken, async (req, res) => {
  try {
    const filter =
      req.user.role === "Manager"
        ? `manager='${req.user.id}'`
        : `employee='${req.user.id}'`;

    const leaveRequests = await pb.collection("leave_requests").getFullList({
      filter,
      expand: "employee,leave_type,manager",
    });

    const branches = await pb.collection("branches").getFullList();
    const departments = await pb.collection("departments").getFullList();
    const roles = await pb.collection("roles").getFullList();

    const branchMap = new Map(
      branches.map((branch) => [branch.id, branch.location])
    );

    const departmentMap = new Map(
      departments.map((department) => [
        department.id,
        department.work_department,
      ])
    );

    const rolesMap = new Map(
      roles.map((role) => [role.id, role.employee_role])
    );

    const requests = leaveRequests.map((request) => {
      const branch = branchMap.get(request.expand.employee.location);
      const department = departmentMap.get(request.expand.employee.department);
      const role = rolesMap.get(request.expand.employee.role);

      return {
        id: request.id,
        employee: {
          id: request.expand.employee.id,
          name: request.expand.employee.name,
          surname: request.expand.employee.surname,
          annual_leave_balance: request.expand.employee.annual_leave_balance,
          sick_leave_balance: request.expand.employee.sick_leave_balance,
          family_leave_balance: request.expand.employee.family_leave_balance,
          location: branch,
          department: department,
          role: role,
          manager: `${request.expand.manager.name} ${request.expand.manager.surname}`,
        },
        leave_type: request.expand.leave_type.leave_type,
        start_date: request.start_date,
        end_date: request.end_date,
        reason: request.reason,
        status: request.status,
        duration: request.duration,
      };
    });
    res.json(requests);
  } catch (error) {
    console.log(error);
    if (error.isAbort) {
      res.status(504).json({ message: "Request timed out" });
    } else {
      res.status(500).send("Failed to get leave requests");
    }
  }
});

// Approve or reject a leave request (admin only)
app.put("/leave-request/:id/approve", authenticateToken, async (req, res) => {
  const { status } = req.body;

  if (req.user.role !== "Manager") return res.status(403).send("Access denied");

  try {
    await pb.collection("leave_requests").update(req.params.id, { status });
    res.send("Leave request status updated");
  } catch (error) {
    console.log(error);
    res.status(500).send("Failed to update leave request");
  }
});

server.listen(3000, () => console.log("Server running on port 3000"));

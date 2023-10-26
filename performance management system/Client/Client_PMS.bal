import ballerina/graphql;
import ballerina/http;
import ballerina/io;

type User record {
    string employeeID;
    string password;
};

type LoggedUserDetailsEmployee record {|
    boolean exists;
    boolean logIn;
|};

type LoggedUserDetailsHodAdmin record {|
    boolean exists;
    boolean logIn;
|};

type UpdatedemployeeDetails record {
    string username;
    string password;
    string supervisorID;
};

type EmployeeDetailsSearchEmployee record {
    string employeeTotalSore;
    string employeeId;
};

type EmployeeDetailsSearchSupervisor record {
    string supervisorID;
    string employeeTotalSore;
    string employeeId;
};

type scoresDetails record {
    string employeeTotalSore;
};

type Rating record {
    string id;
    int supervisorID;
    int rating;
};

type kpi record {
    string kpiId;
    string kpiName;
    int idEmployees;
    int score;
    boolean status;
    string unit;
};

type UpdatedKpi record {
    string kpiName;
    boolean status;
    int score;
};

type DepartmentObjective record {
    string departmentId;
    string departmentName;
    string departmentObjective;
};

public function main() returns error? {
    graphql:Client graphqlClient = check new("http://localhost:9000/PMS");

    // Sample login request for employee
    User employeeUser = {employeeID: "employee123", password: "password123"};
    LoggedUserDetailsEmployee employeeLoginResponse = check graphqlClient->loginEmployee(employeeUser);
    io:println("Employee Login Response: ", employeeLoginResponse);

    // Sample login request for HOD
    User hodUser = {employeeID: "hod456", password: "hodpassword"};
    LoggedUserDetailsHodAdmin hodLoginResponse = check graphqlClient->loginHOD(hodUser);
    io:println("HOD Login Response: ", hodLoginResponse);

    // Sample login request for Supervisor
    User supervisorUser = {employeeID: "supervisor789", password: "supervisorpassword"};
    LoggedUserDetailsEmployee supervisorLoginResponse = check graphqlClient->loginSupervisor(supervisorUser);
    io:println("Supervisor Login Response: ", supervisorLoginResponse);

    // Sample create department objective request
    DepartmentObjective newDepartmentObjective = {departmentId: "dept123", departmentName: "HR", departmentObjective: "Improve employee relations"};
    error|string createDepartmentObjectiveResponse = check graphqlClient->createDepartmentObjective(newDepartmentObjective);
    io:println("Create Department Objective Response: ", createDepartmentObjectiveResponse);

    // Sample delete department objective request
    string departmentIdToDelete = "dept456";
    error|string deleteDepartmentObjectiveResponse = check graphqlClient->deleteDepartmentObjective(departmentIdToDelete);
    io:println("Delete Department Objective Response: ", deleteDepartmentObjectiveResponse);

    // Sample totalScores request for employee
    EmployeeDetailsSearchEmployee employeeSearch = {employeeTotalSore: "250", employeeId: "emp789"};
    scoresDetails employeeTotalScoresResponse = check graphqlClient->totalScores(employeeSearch);
    io:println("Employee Total Scores Response: ", employeeTotalScoresResponse);

    // Sample assignEmployeeSupervisor request
    UpdatedemployeeDetails assignSupervisorDetails = {username: "employee123", password: "newSupervisorPassword", supervisorID: "supervisorNew"};
    error|string assignEmployeeSupervisorResponse = check graphqlClient->assignEmployeeSupervisor(assignSupervisorDetails);
    io:println("Assign Employee Supervisor Response: ", assignEmployeeSupervisorResponse);

    // Sample approveKPi request for supervisor
    UpdatedKpi approveKpiDetails = {kpiName: "Kpi123", status: true, score: 95};
    error|string approveKpiResponse = check graphqlClient->approveKPi(approveKpiDetails);
    io:println("Approve KPI Response: ", approveKpiResponse);

    // Sample deleteKPI request
    string kpiIdToDelete = "kpi456";
    error|string deleteKpiResponse = check graphqlClient->deleteKPI(kpiIdToDelete);
    io:println("Delete KPI Response: ", deleteKpiResponse);

    // Sample updateKPi request
    UpdatedKpi updateKpiDetails = {kpiName: "Kpi123", status: true, score: 85};
    error|string updateKpiResponse = check graphqlClient->updateKPi(updateKpiDetails);
    io:println("Update KPI Response: ", updateKpiResponse);

    // Sample employeeScores request for supervisor
    EmployeeDetailsSearchSupervisor supervisorSearch = {supervisorID: "supervisor123", employeeTotalSore: "300", employeeId: "emp789"};
    scoresDetails employeeScoresResponse = check graphqlClient->employeeScores(supervisorSearch);
    io:println("Employee Scores Response: ", employeeScoresResponse);

    // Sample gradeKPi request for supervisor
    UpdatedKpi gradeKpiDetails = {kpiName: "Kpi123", status: true, score: 95};
    error|string gradeKpiResponse = check graphqlClient->gradeKPi(gradeKpiDetails);
    io:println("Grade KPI Response: ", gradeKpiResponse);

    // Sample createKPI request for employee
    kpi newKpi = {kpiId: "kpi123", kpiName: "KpiName", idEmployees: 123, score: 85, status: true, unit: "HR"};
    error|string createKpiResponse = check graphqlClient->createKPI(newKpi);
    io:println("Create KPI Response: ", createKpiResponse);

    // Sample rateSupervisor request
    Rating newRating = {id: "rating123", supervisorID: 123, rating: 4};
    error|string rateSupervisorResponse = check graphqlClient->rateSupervisor(newRating);
    io:println("Rate Supervisor Response: ", rateSupervisorResponse);

    // Sample scores request for employee
    EmployeeDetailsSearchEmployee employeeScoresSearch = {employeeTotalSore: "250", employeeId: "emp789"};
    scoresDetails employeeScoresResponse = check graphqlClient->scores(employeeScoresSearch);
    io:println("Employee Scores Response: ", employeeScoresResponse);
}

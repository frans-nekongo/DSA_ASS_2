import ballerina/graphql;
import ballerina/http;
import ballerina/io;

type ProductResponse record {|
    record {|anydata dt;|} data;
|};

//functions
function displayLoginOptions() {
    io:println("Please select an option:");
    io:println("1. HOD");
    io:println("2. Supervisor");
    io:println("3. Employee");
    io:println("0. Exit");
}

function displayHODOptions() {
    io:println("Please select an option:");
    io:println("1. Create department objectives.");
    io:println("2. Delete department objectives.");
    io:println("3. View Employees Total Scores.");
    io:println("4. Assign Employee Supervisor.");
    io:println("0. Exit");
}

function displaySupervisorOptions() {
    io:println("Please select an option:");
    io:println("1. HApprove Employee's KPIs.OD");
    io:println("2. Delete Employee’s KPIs.");
    io:println("3. Update Employee's KPIs.");
    io:println("4. View Employee's KPIs(Only employees assigned to him/her)..");
    io:println("0. Exit");
}

function displayEmployeeOptions() {
    io:println("Please select an option:");
    io:println("1. Create KPIs");
    io:println("2. Grade Supervisor");
    io:println("3. View Scores");
    io:println("0. Exit");
}

public function main() returns error? {
    // Instantiate the GraphQL client
    graphql:Client graphqlClient = check new ("http://localhost:9000/PMS");

    // Define GraphQL queries/mutations
    string loginEmployeeQuery = string `
    query loginEmployee($user: User) {
        loginEmployee(user: $user) {
            exists
            logIn
        }
    }`;

    string loginHODQuery = string `
    query loginHOD($user: User) {
        loginHOD(user: $user) {
            exists
            logIn
        }
    }`;

    string loginSupervisorQuery = string `
    query loginSupervisor($user: User) {
        loginSupervisor(user: $user) {
            exists
            logIn
        }
    }`;

    string createDepartmentObjectiveMutation = string `
    mutation createDepartmentObjective($newDepartmentObjective: DepartmentObjective) {
        createDepartmentObjective(newDepartmentObjective: $newDepartmentObjective)
    }`;

    string deleteDepartmentObjectiveMutation = string `
    mutation deleteDepartmentObjective($departmentId: String) {
        deleteDepartmentObjective(departmentId: $departmentId)
    }`;

    string totalScoresQuery = string `
    query totalScores($employeeDetailsSearchEmployee: EmployeeDetailsSearchEmployee) {
        totalScores(employeeDetailsSearchEmployee: $employeeDetailsSearchEmployee) {
            employeeTotalSore
        }
    }`;

    string assignEmployeeSupervisorMutation = string `
    mutation assignEmployeeSupervisor($updatedEmployeeDetails: UpdatedemployeeDetails) {
        assignEmployeeSupervisor(updatedEmployeeDetails: $updatedEmployeeDetails)
    }`;

    string approveKpiMutation = string `
    mutation approveKpi($updatedKpi: UpdatedKpi) {
        approveKpi(updatedKpi: $updatedKpi)
    }`;

    string deleteKpiMutation = string `
    mutation deleteKpi($kpiId: String) {
        deleteKPI(kpiId: $kpiId)
    }`;

    string updateKpiMutation = string `
    mutation updateKpi($updatedKpi: UpdatedKpi) {
        updateKpi(updatedKpi: $updatedKpi)
    }`;

    string createKpiMutation = string `
    mutation createKpi($newKpi: kpi) {
        createKPI(newKpi: $newKpi)
    }`;

    string rateSupervisorMutation = string `
    mutation rateSupervisor($newRating: Rating) {
        rateSupervisor(newRating: $newRating)
    }`;

    string viewEmployeeScoresQuery = string `
    query viewEmployeeScores($employeeDetailsSearchEmployee: EmployeeDetailsSearchEmployee) {
        scores(employeeDetailsSearchEmployee: $employeeDetailsSearchEmployee) {
            employeeTotalSore
        }
    }`;

    // startiing ui section
    User user1 = {employeeID: "employee123", password: "password123"};
    DepartmentObjective newDepartmentObjective1 = {
        departmentId: "dept123",
        departmentName: "Dept Name",
        departmentObjective: "Objective Description"
    };

    EmployeeDetailsSearchEmployee searchEmployee1 = {employeeTotalSore: "employeeTotalSore", employeeId: "employeeId"};

    UpdatedemployeeDetails updatedEmployeeDetails1 = {username: "username", password: "password", supervisorID: "supervisor123"};

    UpdatedKpi updatedKpi1 = {kpiName: "kpiName", status: true, score: 100};

    kpi newKpi1 = {kpiId: "kpiId", kpiName: "kpiName", idEmployees: 1, score: 100, status: true, unit: "unit"};

    Rating newRating1 = {id: "id123", supervisorID: 123, rating: 5};

    while (true) {
        displayLoginOptions();
        boolean loggedin;
        string option = io:readln("Enter your option: ");

        match (option) {
            "1" => {
                //HOD login
                string EmployeeID = io:readln("Enter employee ID: ");
                string Password = io:readln("Enter password: ");
                
                ProductResponse loginHODResponse = check graphqlClient->execute(loginHODQuery, {employeeID: EmployeeID, password: Password});
                io:println("Login HOD Response: ", loginHODResponse);
                if loginHODResponse is error {
                    io:println("Invalid credentials");
                } else {
                    loggedin = true;
                }
            }
            "2" => {
                //Supervisor login
                ProductResponse loginSupervisorResponse = check graphqlClient->execute(loginSupervisorQuery, {"user": user1});
                io:println("Login Supervisor Response: ", loginSupervisorResponse);
            }
            "3" => {
                //Employee login
                ProductResponse loginEmployeeResponse = check graphqlClient->execute(loginEmployeeQuery, {employeeID: "employee123", password: "password123"});
                io:println("Login Employee Response: ", loginEmployeeResponse);
            }
            _ => {
                io:println("Invalid option");
            }
        }
    }

    // Perform GraphQL operations

    ProductResponse createDepartmentObjectiveResponse = check graphqlClient->execute(createDepartmentObjectiveMutation, {"newDepartmentObjective": departmentObjective1});
    io:println("Create Department Objective Response: ", createDepartmentObjectiveResponse);

    ProductResponse deleteDepartmentObjectiveResponse = check graphqlClient->execute(deleteDepartmentObjectiveMutation, {"departmentId": "dept123"});
    io:println("Delete Department Objective Response: ", deleteDepartmentObjectiveResponse);

    ProductResponse totalScoresResponse = check graphqlClient->execute(totalScoresQuery, {"employeeDetailsSearchEmployee": searchEmployee1});
    io:println("Total Scores Response: ", totalScoresResponse);

    ProductResponse assignEmployeeSupervisorResponse = check graphqlClient->execute(assignEmployeeSupervisorMutation, {"updatedEmployeeDetails": updatedEmployeeDetails1});
    io:println("Assign Employee Supervisor Response: ", assignEmployeeSupervisorResponse);

    ProductResponse approveKpiResponse = check graphqlClient->execute(approveKpiMutation, {"updatedKpi": updatedKpi1});
    io:println("Approve KPI Response: ", approveKpiResponse);

    ProductResponse deleteKpiResponse = check graphqlClient->execute(deleteKpiMutation, {"kpiId": "kpi123"});
    io:println("Delete KPI Response: ", deleteKpiResponse);

    ProductResponse updateKpiResponse = check graphqlClient->execute(updateKpiMutation, {"updatedKpi": updatedKpi1});
    io:println("Update KPI Response: ", updateKpiResponse);

    ProductResponse createKpiResponse = check graphqlClient->execute(createKpiMutation, {"newKpi": newKpi1});
    io:println("Create KPI Response: ", createKpiResponse);

    ProductResponse rateSupervisorResponse = check graphqlClient->execute(rateSupervisorMutation, {"newRating": newRating1});
    io:println("Rate Supervisor Response: ", rateSupervisorResponse);

    ProductResponse viewEmployeeScoresResponse = check graphqlClient->execute(viewEmployeeScoresQuery, {"employeeDetailsSearchEmployee": searchEmployee1});
    io:println("View Employee Scores Response: ", viewEmployeeScoresResponse);
}

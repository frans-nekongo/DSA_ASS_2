import ballerina/graphql;
//import ballerina/http;
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

    string viewKpiQuery = string `
    query viewKpi($kpiId: String) {
        kpi(kpiId: $kpiId) {
            kpiId
            kpiName
            idEmployees
            score
            status
            unit
        }
    }`;
    

    // startiing ui section
  
   

    while (true) {
        displayLoginOptions();
        boolean loggedin;
        string option = io:readln("Enter your option: ");

        match (option) {
            "1" => {
                //HOD login
                string EmployeeID = io:readln("Enter employee ID: ");
                string Password = io:readln("Enter password: ");

                error|ProductResponse loginHODResponse = check graphqlClient->execute(loginHODQuery, {employeeID: EmployeeID, password: Password});
                io:println("Login HOD Response: ", loginHODResponse);
                if loginHODResponse is error {
                    io:println("Invalid credentials");
                } else {
                    loggedin = true;

                    //
                    displayHODOptions();
                    while (true) {
                        string option1 = io:readln("Enter your option: ");

                        match (option1) {
                            "1" => {
                                string departmentObjective = io:readln("Enter department objective: ");
                                string departmentName = io:readln("Enter department name: ");
                                string departmentId = io:readln("Enter department id: ");

                                //Create department objectives.
                                ProductResponse createDepartmentObjectiveResponse = check graphqlClient->execute(createDepartmentObjectiveMutation, {departmentId: departmentId, departmentName: departmentName, departmentObjective: departmentObjective});
                                io:println("Create Department Objective Response: ", createDepartmentObjectiveResponse);

                            }
                            "2" => {
                                string departmentId = io:readln("Enter department id: ");

                                //Delete department objectives.
                                ProductResponse deleteDepartmentObjectiveResponse = check graphqlClient->execute(deleteDepartmentObjectiveMutation, {departmentId: departmentId});
                                io:println("Delete Department Objective Response: ", deleteDepartmentObjectiveResponse);
                            }
                            "3" => {
                                string searchEmployee = io:readln("Enter employee id: ");
                                //View Employee Total scores.

                                ProductResponse totalScoresResponse = check graphqlClient->execute(totalScoresQuery, {searchEmployee: searchEmployee});
                                io:println("Total Scores Response: ", totalScoresResponse);
                            }
                            "4" => {
                                string employeeId = io:readln("Enter employee id: ");
                                string supervisorId = io:readln("Enter supervisor id: ");


                                //Assign Employee Supervisor.
                                ProductResponse assignEmployeeSupervisorResponse = check graphqlClient->execute(assignEmployeeSupervisorMutation, {employeeId: employeeId, supervisorId: supervisorId});
                                io:println("Assign Employee Supervisor Response: ", assignEmployeeSupervisorResponse);
                            }
                            _ => {
                                io:println("Invalid option");
                            }
                        }
                    }
                }
            }
            "2" => {
                //Supervisor login
                string EmployeeID = io:readln("Enter employee ID: ");
                string Password = io:readln("Enter password: ");

                error|ProductResponse loginSupervisorResponse = check graphqlClient->execute(loginSupervisorQuery, {employeeID: EmployeeID, password: Password});
                io:println("Login Supervisor Response: ", loginSupervisorResponse);
                if loginSupervisorResponse is error {
                    io:println("Invalid credentials");
                } else {
                    loggedin = true;

                    //
                    displaySupervisorOptions();
                    while (true) {
                        string option2 = io:readln("Enter your option: ");

                        match (option2) {
                            "1" => {
                                string kpiId = io:readln("Enter kpi id: ");
                                string employeeId = io:readln("Enter employee id: ");
                                string kpiistatus = io:readln("Enter kpi status: ");

                                //Approve Employee's KPIs
                                ProductResponse approveKpiResponse = check graphqlClient->execute(approveKpiMutation, {kpiId: kpiId, employeeId: employeeId, kpiistatus: kpiistatus});
                                io:println("Approve KPI Response: ", approveKpiResponse);

                            }
                            "2" => {
                                string kpiId = io:readln("Enter kpi id: ");

                                //Delete Employee’s KPIs
                                ProductResponse deleteKpiResponse = check graphqlClient->execute(deleteKpiMutation, {kpiId: kpiId});
                                io:println("Delete KPI Response: ", deleteKpiResponse);
                            }
                            "3" => {
                                string kpiId = io:readln("Enter kpi id: ");
                                string employeeId = io:readln("Enter employee id: ");
                                string kpiname = io:readln("Enter kpi name: ");
                                string kpiscore = io:readln("Enter kpi score: ");

                                //Update Employee’s KPIs
                                ProductResponse updateKpiResponse = check graphqlClient->execute(updateKpiMutation, {kpiId: kpiId, employeeId: employeeId, kpiname: kpiname, kpiscore: kpiscore});
                                io:println("Update KPI Response: ", updateKpiResponse);
                            }
                            "4" => {
                                string kpiId = io:readln("Enter kpi id: ");

                                //View Employee’s KPIs
                                ProductResponse viewKpiResponse = check graphqlClient->execute(viewKpiQuery, {kpiId: kpiId});
                                io:println("View KPI Response: ", viewKpiResponse);
                            }
                            _ => {
                                io:println("Invalid option");
                            }
                        }
                    }

                }
            }
            "3" => {
                //Employee login
                string EmployeeID = io:readln("Enter employee ID: ");
                string Password = io:readln("Enter password: ");
                error|ProductResponse loginEmployeeResponse = check graphqlClient->execute(loginEmployeeQuery, {employeeID: EmployeeID, password: Password});
                io:println("Login Employee Response: ", loginEmployeeResponse);
                if loginEmployeeResponse is error {
                    io:println("Invalid credentials");
                } else {
                    loggedin = true;

                    //
                    displayEmployeeOptions();
                    while (true) {
                        string option3 = io:readln("Enter your option: ");

                        match (option3) {
                            "1" => {
                                string kpiID = io:readln("Enter kpi id: ");
                                string kpiName = io:readln("Enter kpi name: ");
                                string idEmployees = io:readln("Enter id employees: ");
                                string score = io:readln("Enter score: ");
                                string status = io:readln("Enter status: ");
                                string unit = io:readln("Enter unit: ");
                                //Create KPIs
                                ProductResponse createKpiResponse = check graphqlClient->execute(createKpiMutation, {kpiID: kpiID,kpiName: kpiName, idEmployees: idEmployees, score: score, status: status, unit: unit});
                                io:println("Create KPI Response: ", createKpiResponse);
                            }
                            "2" => {
                                string supervisorID = io:readln("Enter supervisor id: ");
                                string rating = io:readln("Enter rating: ");

                                //Grade Supervisor
                                ProductResponse rateSupervisorResponse = check graphqlClient->execute(rateSupervisorMutation, {supervisorID: supervisorID, rating: rating});
                                io:println("Rate Supervisor Response: ", rateSupervisorResponse);
                            }
                            "3" => {
                                string employeeId = io:readln("Enter employee id: ");

                                //View scores
                                ProductResponse viewEmployeeScoresResponse = check graphqlClient->execute(viewEmployeeScoresQuery, {employeeId: employeeId});
                                io:println("View Employee Scores Response: ", viewEmployeeScoresResponse);
                            }
                            _ => {
                                io:println("Invalid option");
                            }
                        }
                    }

                }
            }
            _ => {
                io:println("Invalid option");
            }
        }
    }


}

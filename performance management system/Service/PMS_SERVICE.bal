import ballerina/graphql;
import ballerina/io;
import ballerinax/mongodb;
//import ballerina/http;


//ratings
type Rating record {
    string id;
    int supervisorID;
    int rating;
};

//kip stuff
type kpi record {
    string kpiId;
    string kpiName;
    int idEmployees;
    int score;
    boolean status;
    string unit;
};

type UpdatedKpi record{
    string kpiName;
    boolean status;
    int score;

};

//departments
type DepartmentObjective record {
    string departmentId;
    string departmentName;
    string departmentObjective;
};

//employee operation stuff
type EmployeeDetails record {
    string id;
    string firstName;
    string lastName;
    string jobTitle;
    string position;
    string role;
    string department;
    string supervisorID;
    string employeeTotalSore;
    string? password;
    string employeeId;
    boolean isAdmin;
};



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

//user types
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


mongodb:ConnectionConfig mongoConfig = {
    connection: {
        host: "localhost",
        port: 27017,
        auth: {
            username: "",
            password: ""
        },
        options: {
            sslEnabled: false,
            serverSelectionTimeout: 5000
        }
    },
    databaseName: "PMS__DB"
};

mongodb:Client db = check new (mongoConfig);
configurable string ratingCollection = "Ratings";
configurable string employeeCollection = "Employees";
configurable string HODCollection = "HOD";
configurable string supervisorCollection = "Supervisor";
configurable string kpiCollection = "KpiS";
configurable string departmentObjectiveCollection="Department";
configurable string databaseName = "PMS__DB";

@graphql:ServiceConfig {
    graphiql: {
        enabled: true,
    path: "/PMS"
    }
}
//listener http:Listener httpListener = check new(9000);

service /PMS on new graphql:Listener(9000) {

   
    resource function get loginEmployee(User user) returns LoggedUserDetailsEmployee|error {
        stream<EmployeeDetails, error?> employeesDeatils = check db->find(employeeCollection, databaseName, {employeeID: user.employeeID, password: user.password}, {});

        EmployeeDetails[] employees = check from var userInfo in employeesDeatils
            select userInfo;
        io:println("employees ", employees);
        // If the user is found return a user or return a string user not found
        if employees.length() > 0 {
            return {exists: true,logIn: true};
        }
        return {
            exists: false,
            logIn: false
        };
    }
     resource function get loginHOD(User user) returns LoggedUserDetailsEmployee|error {
        stream<EmployeeDetails, error?> employeesDeatils = check db->find(HODCollection, databaseName, {employeeID: user.employeeID, password: user.password}, {});

        EmployeeDetails[] employees = check from var userInfo in employeesDeatils
            select userInfo;
        io:println("HOD ", employees);
        // If the user is found return a user or return a string user not found
        if employees.length() > 0 {
            return {exists: true,logIn: true};
        }
        return {
            exists: false,
            logIn: false
        };
    }
    resource function get loginSupervisor(User user) returns LoggedUserDetailsEmployee|error {
        stream<EmployeeDetails, error?> employeesDeatils = check db->find(supervisorCollection, databaseName, {employeeID: user.employeeID, password: user.password}, {});

        EmployeeDetails[] employees = check from var userInfo in employeesDeatils
            select userInfo;
        io:println("Supervisor ", employees);
        // If the user is found return a user or return a string user not found
        if employees.length() > 0 {
            return {exists: true,logIn: true};
        }
        return {
            exists: false,
            logIn: false
        };
    }
    
    //HOD
    //Create department objectives. 
    remote function createDepartmentObjective(DepartmentObjective newDepartmentObjective) returns error|string {

        map<json> doc = <map<json>>{departmentId:newDepartmentObjective.departmentId, departmentName:newDepartmentObjective.departmentName, departmentObjective:newDepartmentObjective.departmentObjective};
        _ = check db->insert(doc, departmentObjectiveCollection, "");
        return string `${newDepartmentObjective.departmentObjective} added successfully`;
    }
    
    //Delete department objectives. 
    remote function deleteDepartmentObjective(string departmentId) returns error|string {
        mongodb:Error|int deleteItem = db->delete(departmentObjectiveCollection, "", {departmentId: departmentId}, false);
        if deleteItem is mongodb:Error {
            return error("Failed to delete KPI");
        } else {
            if deleteItem > 0 {
                return string `${departmentId} deleted successfully`;
            } else {
                return string `KPI not found`;
            }
        }

    }

    //View Employees Total Scores. 
     resource function get totalScores(EmployeeDetailsSearchEmployee employeeDetailsSearchEmployee) returns scoresDetails|error {
        stream<EmployeeDetails, error?> employeeDeatils = check db->find(employeeCollection, databaseName, {}, {});

        EmployeeDetails[] employees = check from var employeeInfo in employeeDeatils
            select employeeInfo;
        io:println("EmployeeDetails ", EmployeeDetailsSearchEmployee);
        // If the employee is found return an employeeTotalSCore or return a string employee not found
        if employees.length() > 0 {
            return {employeeTotalSore: employeeDetailsSearchEmployee.employeeTotalSore};
        }
        return {
            employeeTotalSore: ""
        };
    }

    //Assign the Employee to a supervisor. 
    remote function assignEmployeeSupervisor(UpdatedemployeeDetails updatedEmployeeDetails) returns error|string {

        map<json> newSupervisorDoc = <map<json>>{"$set": {"supervisorID": updatedEmployeeDetails.supervisorID}};

        int updatedCount = check db->update(newSupervisorDoc, employeeCollection, databaseName, {supervisorID: updatedEmployeeDetails.supervisorID}, true, false);
        io:println("Updated Count ", updatedCount);

        if updatedCount > 0 {
            return string `${updatedEmployeeDetails.supervisorID} supervisor has been assigned`;
        }
        return "Failed to assign supervisor";
    }

    //SUPERVISOR
    //Approve Employee's KPIs. 
     remote function aproveKPi(UpdatedKpi updatedKpi) returns error|string {

        map<json> newKpiDoc = <map<json>>{"$set": {"status": updatedKpi.status}};

        int updatedCount = check db->update(newKpiDoc, kpiCollection, databaseName, {status: updatedKpi.status}, true, false);
        io:println("Updated Count ", updatedCount);

        if updatedCount > 0 {
            return string `${updatedKpi.kpiName} kpi has been approved`;
        }
        return "Failed to approve kpi";
    }

    //Delete Employee’s KPIs. 
    remote function deleteKPI(string kpiId) returns error|string {
        mongodb:Error|int deleteItem = db->delete(kpiCollection, "", {kpiId: kpiId}, false);
        if deleteItem is mongodb:Error {
            return error("Failed to delete KPI");
        } else {
            if deleteItem > 0 {
                return string `${kpiId} deleted successfully`;
            } else {
                return string `KPI not found`;
            }
        }

    }
    //Update Employee's KPIs. 
     remote function updateKPi(UpdatedKpi updatedKpi) returns error|string {

        map<json> newKpiDoc = <map<json>>{"$set": {"kpiname": updatedKpi.kpiName}};

        int updatedCount = check db->update(newKpiDoc, kpiCollection, databaseName, {score: updatedKpi.score}, true, false);
        io:println("Updated Count ", updatedCount);

        if updatedCount > 0 {
            return string `${updatedKpi.score} kpi has been updated successfully`;
        }
        return "Failed to update";
    }

    //View Employee Scores. (Only employees assigned to him/her).
    resource function get employeeScores(EmployeeDetailsSearchSupervisor employeeDetailsSearchSupervisor) returns scoresDetails|error {
        stream<EmployeeDetails, error?> employeeDeatils = check db->find(employeeCollection, databaseName, {supervisorID:employeeDetailsSearchSupervisor.supervisorID,employeeTotalSore:employeeDetailsSearchSupervisor.employeeTotalSore,employeeId:employeeDetailsSearchSupervisor.employeeId}, {});

        EmployeeDetails[] employees = check from var employeeInfo in employeeDeatils
            select employeeInfo;
        io:println("EmployeeDetails ", EmployeeDetailsSearchSupervisor);
        // If the employee is found return an employeeTotalSCore or return a string employee not found
        if employees.length() > 0 {
            return {employeeTotalSore: employeeDetailsSearchSupervisor.employeeTotalSore};
        }
        return {
            employeeTotalSore: ""
        };
    }

    // Grade the employee’s KPIs
    remote function gradeKPi(UpdatedKpi updatedKpi) returns error|string {

        map<json> newKpiDoc = <map<json>>{"$set": {"score": updatedKpi.score}};

        int updatedCount = check db->update(newKpiDoc, kpiCollection, databaseName, {kpiName: updatedKpi.kpiName}, true, false);
        io:println("Updated Count ", updatedCount);

        if updatedCount > 0 {
            return string `${updatedKpi.kpiName} kpi has been changed successfully`;
        }
        return "Failed to updated";
    }
    

    //EMPLOYEE
    //Create their KPIs 
    
    remote function createKPI(kpi newKpi) returns error|string {

        map<json> doc = <map<json>>{kpiId:newKpi.kpiId,kpiName:newKpi.kpiName,idEmployees:newKpi.idEmployees,score:newKpi.score,status:newKpi.status,unit:newKpi.unit};
        _ = check db->insert(doc, kpiCollection, "");
        return string `${newKpi.kpiName} added successfully`;
    }

    //Grade their Supervisor 
    remote function rateSupervisor(Rating newRating) returns error|string {
        map<json> doc = <map<json>>newRating.toJson();
        _ = check db->insert(doc, ratingCollection, "");
        return string `${newRating.supervisorID} added successfully`;
    }

    //View Their Scores
    resource function get scores(EmployeeDetailsSearchEmployee employeeDetailsSearchEmployee) returns scoresDetails|error {
        stream<EmployeeDetails, error?> employeeDeatils = check db->find(employeeCollection, databaseName, {employeeTotalSore:employeeDetailsSearchEmployee.employeeTotalSore,employeeId:employeeDetailsSearchEmployee.employeeId}, {});

        EmployeeDetails[] employees = check from var employeeInfo in employeeDeatils
            select employeeInfo;
        io:println("EmployeeDetails ", EmployeeDetailsSearchEmployee);
        // If the employee is found return an employeeTotalSCore or return a string employee not found
        if employees.length() > 0 {
            return {employeeTotalSore: employeeDetailsSearchEmployee.employeeTotalSore};
        }
        return {
            employeeTotalSore: ""
        };
    }

}

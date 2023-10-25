import ballerina/graphql;
import ballerina/io;
import ballerinax/mongodb;

type Rating record {
    string id;
    int supervisorID;
    int rating;
};

type User record {
    string employeeID;
    string password;
};
type kpi record {
    string kpiId;
    string kpiName;
    int idEmployees;
    int score;
    boolean status;
    string unit;
};

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

type scoresDetails record {
    string employeeTotalSore;
    
};

type UpdatedemployeeDetails record {
    string username;
    string password;
};

type LoggedemployeeDetails record {|
    string username;
    boolean isAdmin;
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
configurable string kpiCollection = "KpiS";
configurable string databaseName = "PMS__DB";

@graphql:ServiceConfig {
    graphiql: {
        enabled: true,
    // Path is optional, if not provided, it will be dafulted to `/graphiql`.
    path: "/PMS"
    }
}
service /PMS on new graphql:Listener(2120) {

    // mutation
    

    // query
    // resource function get login(User user) returns LoggedemployeeDetails|error {
    //     stream<employeeDetails, error?> employeesDeatils = check db->find(employeeCollection, databaseName, {username: user.username, password: user.password}, {});

    //     employeeDetails[] employees = check from var userInfo in employeesDeatils
    //         select userInfo;
    //     io:println("employees ", employees);
    //     // If the user is found return a user or return a string user not found
    //     if employees.length() > 0 {
    //         return {username: employees[0].username, isAdmin: employees[0].isAdmin};
    //     }
    //     return {
    //         username: "",
    //         isAdmin: false
    //     };
    // }

    //HOD
    //SUPERVISOR
    
    //EMPLOYEE
    
    remote function createKPI(kpi newKpi) returns error|string {

        map<json> doc = <map<json>>{kpiId:newKpi.kpiId,kpiName:newKpi.kpiName,idEmployees:newKpi.idEmployees,score:newKpi.score,status:newKpi.status,unit:newKpi.unit};
        _ = check db->insert(doc, kpiCollection, "");
        return string `${newKpi.kpiName} added successfully`;
    }

    remote function rateSupervisor(Rating newRating) returns error|string {
        map<json> doc = <map<json>>newRating.toJson();
        _ = check db->insert(doc, ratingCollection, "");
        return string `${newRating.supervisorID} added successfully`;
    }

    resource function get scores(User user) returns scoresDetails|error {
        stream<EmployeeDetails, error?> employeeDeatils = check db->find(employeeCollection, databaseName, {}, {});

        EmployeeDetails[] users = check from var userInfo in employeeDeatils
            select userInfo;
        io:println("Users ", users);
        // If the user is found return a user or return a string user not found
        if users.length() > 0 {
            return {username: users[0].username, isAdmin: users[0].isAdmin};
        }
        return {
            username: "",
            isAdmin: false
        };
    }
}

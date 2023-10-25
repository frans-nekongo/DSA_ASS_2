import ballerina/graphql;
import ballerina/io;
import ballerinax/mongodb;

type Rating record {
    string id;
    int supervisorID;
    int rating;
};

type User record {
    string username;
    string password;
};

type employeeDetails record {
    string username;
    string? password;
    boolean isAdmin;
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
    remote function addProduct(Rating newRating) returns error|string {
        map<json> doc = <map<json>>newRating.toJson();
        _ = check db->insert(doc, ratingCollection, "");
        return string `${newRating.supervisorID} added successfully`;
    }

    // query
    resource function get login(User user) returns LoggedemployeeDetails|error {
        stream<employeeDetails, error?> employeesDeatils = check db->find(employeeCollection, databaseName, {username: user.username, password: user.password}, {});

        employeeDetails[] employees = check from var userInfo in employeesDeatils
            select userInfo;
        io:println("employees ", employees);
        // If the user is found return a user or return a string user not found
        if employees.length() > 0 {
            return {username: employees[0].username, isAdmin: employees[0].isAdmin};
        }
        return {
            username: "",
            isAdmin: false
        };
    }
//  resource  function post insertKpi(string kpi_name, string idEmployees, string score, string status, string unit) returns error? {
//     map<json> document = {
//         //"_id": _id,
//         "kpi_name": kpi_name,
//         "idEmployees": idEmployees,
//         "score": score,
//         "status": status,
//         "unit": unit
//     };

//     check db->insert(document, "kpi");
// }

}

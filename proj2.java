import java.sql.*;
import oracle.jdbc.*;
import java.math.*;
import java.io.*;
import java.awt.*;
import oracle.jdbc.pool.OracleDataSource;
import java.util.Arrays;
import java.util.List;


public class proj2 {
    public static void main (String args []) throws SQLException {
        try
        {
            //Connection to Oracle server
            OracleDataSource ds = new oracle.jdbc.pool.OracleDataSource();
            ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:ACAD111");
            Connection conn = ds.getConnection("jwhitak4", "Scwgya1L");
            /*Statement s = conn.createStatement();
            s.executeUpdate("start packheader;");
            s.executeUpdate("start packbody;");
            s.executeUpdate("start triggers;");
            s.executeUpdate("start table_filler;");
            */
            boolean flag = true;
            while(flag == true) { //while loop with bool var to allow repeated command execution
                BufferedReader  readKeyBoard;
                String option;
                String sub_option;
                readKeyBoard = new BufferedReader(new InputStreamReader(System.in));
                System.out.println("Please select a command option"); //command menu 
                System.out.println("1. Display a table");
                System.out.println("2. Add a student");
                System.out.println("3. Delete a student");
                System.out.println("4. Enroll a student into a class");
                System.out.println("5. Drop a student from a class");
                System.out.println("6. Find all prerequisites for a class");
                System.out.println("7. Show everyone enrolled in class");
                System.out.println("8. Display all classes a student is enrolled in");
                System.out.println("9. Exit java program");
                option = readKeyBoard.readLine();

                if(option.equals("1")) {
                    System.out.println("1. Display students table"); //sub menu so user can specify which table to display
                    System.out.println("2. Display courses table");
                    System.out.println("3. Display classes table");
                    System.out.println("4. Display enrollments table");
                    System.out.println("5. Display prerequisites table");
                    System.out.println("6. Display logs table");
                    sub_option = readKeyBoard.readLine();
                    switch(sub_option) {
                        case "1":
                            CallableStatement cs = conn.prepareCall("begin ? := pack2.show_students(); end;"); //each case uses the same logic/code to store the plsql function,
                            cs.registerOutParameter(1, OracleTypes.CURSOR);                                    //and then print out the attributes of each tuple with a while loop to loop through the ResultSet var
                            cs.execute();
                            ResultSet rs = (ResultSet)cs.getObject(1);
                            while (rs.next()) {
                                System.out.println(rs.getString(1) + "\t" +
                                    rs.getString(2) + "\t" + rs.getString(3) + "\t" +
                                    rs.getString(4) +
                                    "\t" + rs.getDouble(5) + "\t" +
                                    rs.getString(6));
                            }
                            cs.close();
                            break;
                        case "2":
                        cs = conn.prepareCall("begin ? := pack2.show_courses(); end;");
                        cs.registerOutParameter(1, OracleTypes.CURSOR);
                        cs.execute();
                        rs = (ResultSet)cs.getObject(1);
                        while (rs.next()) {
                            System.out.println(rs.getString(1) + "\t" +
                                rs.getInt(2) + "\t" + rs.getString(3));
                        }
                        cs.close();
                        break;
                        case "3":
                        cs = conn.prepareCall("begin ? := pack2.show_classes(); end;");
                        cs.registerOutParameter(1, OracleTypes.CURSOR);
                        cs.execute();
                        rs = (ResultSet)cs.getObject(1);
                        while (rs.next()) {
                            System.out.println(rs.getString(1) + "\t" +
                                rs.getString(2) + "\t" + rs.getInt(3) + "\t" + rs.getInt(4)
                                + "\t" + rs.getInt(5) + "\t" + rs.getString(6) + "\t" + rs.getInt(7)
                                + "\t" + rs.getInt(8));
                        }
                        cs.close();
                        break;
                        case "4":
                        cs = conn.prepareCall("begin ? := pack2.show_enrollments(); end;");
                        cs.registerOutParameter(1, OracleTypes.CURSOR);
                        cs.execute();
                        rs = (ResultSet)cs.getObject(1);
                        while (rs.next()) {
                            System.out.println(rs.getString(1) + "\t" +
                                rs.getString(2) + "\t" + rs.getString(3));
                        }
                        cs.close();
                        break;
                        case "5":
                        cs = conn.prepareCall("begin ? := pack2.show_prerequisites(); end;");
                        cs.registerOutParameter(1, OracleTypes.CURSOR);
                        cs.execute();
                        rs = (ResultSet)cs.getObject(1);
                        while (rs.next()) {
                            System.out.println(rs.getString(1) + "\t" +
                                rs.getInt(2) + "\t" + rs.getString(3) + "\t" + rs.getInt(4));
                        }
                        cs.close();
                        break;
                        case "6":
                        cs = conn.prepareCall("begin ? := pack2.show_logs(); end;");
                        cs.registerOutParameter(1, OracleTypes.CURSOR);
                        cs.execute();
                        rs = (ResultSet)cs.getObject(1);
                        while (rs.next()) {
                            String logid = Integer.toString(rs.getInt(1));
                            while(logid.length() != 7) {
                                logid = "0" + logid;
                            }
                            System.out.println(logid + "\t" +
                                rs.getString(2) + "\t" + rs.getDate(3) + "\t" + rs.getString(4)
                                + "\t" + rs.getString(5) + "\t" + rs.getString(6));
                        }
                        cs.close();
                        break;
                    }
                }
                else if(option.equals("2")){
                  System.out.print("Enter SID: ");          //prompt user for student information
                  String sid = readKeyBoard.readLine();
                  System.out.print("Enter first name: ");
                  String fname = readKeyBoard.readLine();
                  System.out.print("Enter last name: ");
                  String lname = readKeyBoard.readLine();
                  System.out.print("Enter status: ");
                  String status = readKeyBoard.readLine();
                  System.out.print("Enter GPA: ");
                  String gpa1 = readKeyBoard.readLine();
                  double gpa = Double.parseDouble(gpa1);
                  System.out.print("Enter email: ");
                  String email = readKeyBoard.readLine();
                  CallableStatement cs = conn.prepareCall("begin ? := pack2.add_student(?,?,?,?,?,?); end;");   //prepare to add attributes using the add_student function with unknown parameters
                  cs.registerOutParameter(1, Types.INTEGER);              
                  cs.setString(2,sid);          // add the stored variable information from user to the CallableStatment and then execute it with execute()
                  cs.setString(3,fname);
                  cs.setString(4,lname);
                  cs.setString(5,status);
                  cs.setDouble(6,gpa);
                  cs.setString(7,email);
                  cs.execute();
                  int ret = cs.getInt(1);
                  if(ret == 1){             //logic for error checking carried over from plsql using java if statements
                    System.out.println("Student successfully inserted");

                  }
                  else{
                    System.out.println("SID has already been used.");
                  }
                }
                else if(option.equals("3")){           
                  System.out.print("Enter SID: ");
                  String sid = readKeyBoard.readLine();
                  Statement st = conn.createStatement();
                  st.executeUpdate("begin dbms_output.enable(); end;");
                  CallableStatement cs = conn.prepareCall("declare num1 integer:= 1000; begin ? := pack2.delete_student(?); dbms_output.get_lines(?, num1); dbms_output.disable(); end;");  //prepare function call with buffer and save dbms_output into array for display
                  cs.registerOutParameter(1, Types.INTEGER);    // define return value
                  cs.setString(2, sid);   //sets parameter with student to delete
                  cs.registerOutParameter(3, Types.ARRAY, "DBMSOUTPUT_LINESARRAY"); //define return type for written output to java terminal
                  cs.execute();
                  int ret = cs.getInt(1);
                  Array array = null;
                  System.out.println("DISPLAYING RESULTS FROM QUERY IF ANY");
                  array = cs.getArray(3);
                  List<Object> l = Arrays.asList((Object[]) array.getArray());  //store query results/output into a List and iterate through them 
                  for(int i = 0 ; i < l.size()-1 ; i++){
                      System.out.println(l.get(i));
                  
                  }
                  if (array != null)
                      array.free();
                }
                else if(option.equals("4")){
                  System.out.print("Enter SID: ");
                  String sid = readKeyBoard.readLine();
                  System.out.print("Enter classid: ");
                  String cid = readKeyBoard.readLine();
                  Statement st = conn.createStatement();
                  st.executeUpdate("begin dbms_output.enable(); end;");
                  CallableStatement cs = conn.prepareCall("declare num1 integer:= 1000; begin ? := pack2.enroll_student(?,?); dbms_output.get_lines(?, num1); dbms_output.disable(); end;"); //prep function to enroll student based on sid input
                  cs.registerOutParameter(1, Types.INTEGER);
                  cs.setString(2, sid);
                  cs.setString(3, cid);
                  cs.registerOutParameter(4, Types.ARRAY, "DBMSOUTPUT_LINESARRAY");
                  cs.execute();
                  int ret = cs.getInt(1);
                  Array array = null;
                  System.out.println("DISPLAYING RESULTS FROM QUERY");
                array = cs.getArray(4);
                List<Object> l = Arrays.asList((Object[]) array.getArray());  //same iteration as above
                for(int i = 0 ; i < l.size()-1 ; i++){
                    System.out.println(l.get(i));

                }
                if (array != null)
                    array.free();
                }
                else if(option.equals("5")){
                  System.out.print("Enter SID: ");
                  String sid = readKeyBoard.readLine();
                  System.out.print("Enter classid: ");
                  String cid = readKeyBoard.readLine();
                  Statement st = conn.createStatement();
                  st.executeUpdate("begin dbms_output.enable(); end;");
                  CallableStatement cs = conn.prepareCall("declare num1 integer:= 1000; begin ? := pack2.drop_student(?,?); dbms_output.get_lines(?, num1); dbms_output.disable(); end;");
                  cs.registerOutParameter(1, Types.INTEGER);
                  cs.setString(2, sid);
                  cs.setString(3, cid);
                  cs.registerOutParameter(4, Types.ARRAY, "DBMSOUTPUT_LINESARRAY");
                  cs.execute();
                  int ret = cs.getInt(1);
                  Array array = null;
                  System.out.println("DISPLAYING RESULTS FROM QUERY");
                array = cs.getArray(4);
                List<Object> l = Arrays.asList((Object[]) array.getArray());
                for(int i = 0 ; i < l.size()-1 ; i++){
                    System.out.println(l.get(i));

                }
                if (array != null)
                    array.free();
                }
                else if(option.equals("6")){
                  System.out.print("Enter Department Code: ");
                  String dc = readKeyBoard.readLine();
                  System.out.print("Enter Course Number: ");
                  String cn1 = readKeyBoard.readLine();
                  int cn = Integer.parseInt(cn1);
                  Statement st = conn.createStatement();
                  st.executeUpdate("begin dbms_output.enable(); end;");
                  CallableStatement cs = conn.prepareCall("declare num1 integer:= 1000; begin ? := pack2.find_all_prereq(?,?); dbms_output.get_lines(?, num1); dbms_output.disable(); end;");
                  cs.registerOutParameter(1, Types.INTEGER);
                  cs.setString(2, dc);
                  cs.setInt(3,cn);
                  cs.registerOutParameter(4, Types.ARRAY, "DBMSOUTPUT_LINESARRAY");
                  cs.execute();
                  int ret = cs.getInt(1);
                  Array array = null;
                  System.out.println("DISPLAYING RESULTS FROM QUERY");
                array = cs.getArray(4);
                List<Object> l = Arrays.asList((Object[]) array.getArray());
                for(int i = 0 ; i < l.size()-1 ; i++){
                    System.out.println(l.get(i));

                }
                if (array != null)
                    array.free();


                }
                else if(option.equals("7")){
                  System.out.print("Enter classid: ");
                  String sid = readKeyBoard.readLine();
                  Statement st = conn.createStatement();
                  st.executeUpdate("begin dbms_output.enable(); end;");
                  CallableStatement cs = conn.prepareCall("declare num1 integer:= 1000; begin ? := pack2.show_all_enrolled(?); dbms_output.get_lines(?, num1); dbms_output.disable(); end;");
                  cs.registerOutParameter(1, Types.INTEGER);
                  cs.setString(2, sid);
                  cs.registerOutParameter(3, Types.ARRAY, "DBMSOUTPUT_LINESARRAY");
                  cs.execute();
                  int ret = cs.getInt(1);
                  Array array = null;
                  System.out.println("DISPLAYING RESULTS FROM QUERY");
                    array = cs.getArray(3);
                    List<Object> l = Arrays.asList((Object[]) array.getArray());
                    for(int i = 0 ; i < l.size()-1 ; i++){
                        System.out.println(l.get(i));

                    }
                    if (array != null)
                        array.free();
                }
                else if(option.equals("8")){
                  System.out.print("Enter SID: ");
                  String sid = readKeyBoard.readLine();
                  Statement st = conn.createStatement();
                  st.executeUpdate("begin dbms_output.enable(); end;");
                  CallableStatement cs = conn.prepareCall("declare num1 integer:= 1000; begin ? := pack2.display_enrolled_classes(?); dbms_output.get_lines(?, num1); dbms_output.disable(); end;");
                  cs.registerOutParameter(1, Types.INTEGER);
                  cs.setString(2, sid);
                  cs.registerOutParameter(3, Types.ARRAY, "DBMSOUTPUT_LINESARRAY");
                  cs.execute();
                  int ret = cs.getInt(1);
                  Array array = null;
                  System.out.println("DISPLAYING RESULTS FROM QUERY");
                    array = cs.getArray(3);
                    List<Object> l = Arrays.asList((Object[]) array.getArray());
                    for(int i = 0 ; i < l.size()-1 ; i++){
                        System.out.println(l.get(i));
                
                    }
                    if (array != null)
                        array.free();
            
            
                }
                else if(option.equals("9")) { //option for ending the while loop and exitting the program
                    flag = false;
                }
                else {
                    System.out.println("Invalid input, try again"); //option error checking
                }
            }

            //close the connection
            //conn.close();
        }
        catch (SQLException ex) { System.out.println ("\n*** SQLException caught ***\n" + ex.getMessage());} //sql exception catching 
        catch (Exception e) {System.out.println ("\n*** other Exception caught ***\n");}
    }
}

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
            Connection conn = ds.getConnection("dwalter2", "Mysterio1");

            while(true) {
                BufferedReader  readKeyBoard;
                String option;
                String sub_option;
                readKeyBoard = new BufferedReader(new InputStreamReader(System.in));
                System.out.println("Please select a command option");
                System.out.println("1. Display a table");
                System.out.println("2. Add a student");
                System.out.println("3. Delete a student");
                System.out.println("4. Enroll a student into a class");
                System.out.println("5. Drop a student from a class");
                System.out.println("6. Find all prerequisites for a class");
                System.out.println("7. Show everyone enrolled in class");
                System.out.println("8. Display all classes a student is enrolled in");
                option = readKeyBoard.readLine();

                if(option.equals("1")) {
                    System.out.println("1. Display students table");
                    System.out.println("2. Display courses table");
                    System.out.println("3. Display classes table");
                    System.out.println("4. Display enrollments table");
                    System.out.println("5. Display prerequisites table");
                    System.out.println("6. Display logs table");
                    sub_option = readKeyBoard.readLine();
                    switch(sub_option) {
                        case "1":
                            CallableStatement cs = conn.prepareCall("begin ? := pack2.show_students(); end;");
                            cs.registerOutParameter(1, OracleTypes.CURSOR);
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
                            System.out.println(rs.getInt(1) + "\t" +
                                rs.getString(2) + "\t" + rs.getDate(3) + "\t" + rs.getString(4)
                                + "\t" + rs.getString(5) + "\t" + rs.getString(6));
                        }
                        cs.close();
                        break;
                    }
                }
                else if(option.equals("2")){
                  System.out.print("Enter SID: ");
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
                  CallableStatement cs = conn.prepareCall("begin ? := pack2.add_student(?,?,?,?,?,?); end;");
                  cs.registerOutParameter(1, Types.INTEGER);
                  cs.setString(2,sid);
                  cs.setString(3,fname);
                  cs.setString(4,lname);
                  cs.setString(5,status);
                  cs.setDouble(6,gpa);
                  cs.setString(7,email);
                  cs.execute();
                  int ret = cs.getInt(1);
                  if(ret == 1){
                    System.out.println("Student successfully inserted");

                  }
                  else{
                    System.out.println("SID has already been used.");
                  }
                }
                else if(option.equals("8")){
                  System.out.print("Enter SID: ");
                  String sid = readKeyBoard.readLine();
                  Statement st = conn.createStatement();
                  st.executeUpdate("begin dbms_output.enable(); end;");
                  CallableStatement cs = conn.prepareCall("declare num1 integer:= 1000; begin ? := pack2.display_enrolled_classes(?); dbms_output.get_lines(?, num1); end;");
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
            }

            //close the connection
            //conn.close();
        }
        catch (SQLException ex) { System.out.println ("\n*** SQLException caught ***\n" + ex.getMessage());}
        catch (Exception e) {System.out.println ("\n*** other Exception caught ***\n");}
    }
}

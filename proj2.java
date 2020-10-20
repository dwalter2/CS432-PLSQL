import java.sql.*;
import oracle.jdbc.*;
import java.math.*;
import java.io.*;
import java.awt.*;
import oracle.jdbc.pool.OracleDataSource;

public class proj2 {
    public static void main (String args []) throws SQLException {
        try
        {
            //Connection to Oracle server
            OracleDataSource ds = new oracle.jdbc.pool.OracleDataSource();
            ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:ACAD111");
            Connection conn = ds.getConnection("jwhitak4", "Scwgya1L");
            
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
            }

            //close the connection
            //conn.close();
        }
        catch (SQLException ex) { System.out.println ("\n*** SQLException caught ***\n" + ex.getMessage());}
        catch (Exception e) {System.out.println ("\n*** other Exception caught ***\n");}
    }
}
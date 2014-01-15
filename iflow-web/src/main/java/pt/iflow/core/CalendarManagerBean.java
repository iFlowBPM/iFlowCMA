package pt.iflow.core;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.ArrayList;

import pt.iflow.api.calendar.Calendar;
import pt.iflow.api.core.CalendarManager;
import pt.iflow.api.db.DatabaseInterface;
import pt.iflow.api.utils.Logger;
import pt.iflow.api.utils.UserInfoInterface;

/**
 * 
 * Calendar Management
 * 
 * 
 */

public class CalendarManagerBean implements CalendarManager {

  private static CalendarManagerBean instance = null;

  private CalendarManagerBean() {
  }

  public static CalendarManagerBean getInstance() {
    if (null == instance)
      instance = new CalendarManagerBean();
    return instance;
  }

  public Calendar getFlowCalendar(UserInfoInterface userInfo, int flowid){
    String userid = userInfo.getUtilizador();
    Calendar cal = new Calendar();          
    
    Connection db = null;
    Statement st = null;
    ResultSet rs = null;

    try {
      db = DatabaseInterface.getConnection(userInfo);
      st = db.createStatement();
      rs = st.executeQuery("select * from calendar where id = (select calendar_id from flow_calendar where flowid = '"+flowid+"')");
      
      if(rs.next()){
        cal.setId(rs.getInt("id"));
        cal.setSunday(rs.getInt("sunday"));
        cal.setMonday(rs.getInt("monday"));
        cal.setTuesday(rs.getInt("tuesday"));
        cal.setWednesday(rs.getInt("wednesday"));
        cal.setThursday(rs.getInt("thursday"));
        cal.setFriday(rs.getInt("friday"));
        cal.setSaturday(rs.getInt("saturday"));
        cal.setDayHours(rs.getInt("day_hours"));
      } else {
        cal = null;
      }
          
      rs.close();
      rs = null;
    } catch (SQLException sqle) {
        //Logger.error(userid, this, "getFlowCalendar","caught sql exception: " + sqle.getMessage(), sqle);
        Logger.debug(userid, this, "getFlowCalendar", "Os calendários não estão definidos, as tabelas necessárias não existem.");
        return null;
    } catch (Exception e) {
        Logger.error(userid, this, "getFlowCalendar","caught exception: " + e.getMessage(), e);
    } finally {
        DatabaseInterface.closeResources(db, st, rs);
    }
return cal;
}
 
  

  public ArrayList<Timestamp> getHolidaysCalendar(UserInfoInterface userInfo, int calendar_id, Timestamp tsStart, Timestamp tsStop){
    String userid = userInfo.getUtilizador();
    ArrayList<Timestamp> holidays = new ArrayList<Timestamp>();           
    
    Connection db = null;
    Statement st = null;
    ResultSet rs = null;
   
    try {
      db = DatabaseInterface.getConnection(userInfo);
      st = db.createStatement();
      rs = st.executeQuery("select * from calendar_holidays where calendar_id = '"+calendar_id+"' and holiday >= '"+tsStart+"' and holiday <= '"+tsStop+"'");
      
      while(rs.next()){
        holidays.add(rs.getTimestamp("holiday"));
      }
          
      rs.close();
      rs = null;
    } catch (SQLException sqle) {
        Logger.error(userid, this, "getHolidaysCalendar","caught sql exception: " + sqle.getMessage(), sqle);
    } catch (Exception e) {
        Logger.error(userid, this, "getHolidaysCalendar","caught exception: " + e.getMessage(), e);
    } finally {
        DatabaseInterface.closeResources(db, st, rs);
    }
return holidays;
}  
  
  public ArrayList<Time> getPeriodsCalendar(UserInfoInterface userInfo, int calendar_id){
    String userid = userInfo.getUtilizador();
    ArrayList<Time> periods = new ArrayList<Time>();           
    
    Connection db = null;
    Statement st = null;
    ResultSet rs = null;

    try {
      db = DatabaseInterface.getConnection(userInfo);
      st = db.createStatement();
      rs = st.executeQuery("select * from calendar_periods where calendar_id = '"+calendar_id+"'");
      
      while(rs.next()){
        periods.add(rs.getTime("period_start"));
        periods.add(rs.getTime("period_end"));
      }
          
      rs.close();
      rs = null;
    } catch (SQLException sqle) {
        Logger.error(userid, this, "getPeriodsCalendar","caught sql exception: " + sqle.getMessage(), sqle);
    } catch (Exception e) {
        Logger.error(userid, this, "getPeriodsCalendar","caught exception: " + e.getMessage(), e);
    } finally {
        DatabaseInterface.closeResources(db, st, rs);
    }
return periods;
} 
  
}

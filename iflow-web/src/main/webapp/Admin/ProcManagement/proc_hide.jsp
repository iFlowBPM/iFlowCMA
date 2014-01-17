<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/core" prefix="c" %>
<%@ taglib uri="http://www.iknow.pt/jsp/jstl/iflow" prefix="if" %>
<%@ include file = "../../inc/defs.jsp" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "javax.sql.*" %>

<%
	String title = messages.getString("proc_hide.title"); 
String sPage = "Admin/ProcManagement/proc_hide";

StringBuffer sbError = new StringBuffer();
String sESCOLHA = messages.getString("const.choose");


boolean bLocked = false;
String sLocked = "";

String sOp = fdFormData.getParameter("op");

String sHidden = fdFormData.getParameter("hide");
if (sHidden == null) {
  sHidden = "0";
	}

//Parametro para Bug 764/918 - lista de processos depois do cancelamento
//O parametro sÃ³ Ã© utilizado para isto, pode ser apagado do url
String sCancel = fdFormData.getParameter("cancel");

if (sCancel == null) {
	sCancel = "false";
	}

String sFirst = fdFormData.getParameter("first");

if (sFirst == null) {
  	sFirst = "false";
	}

if (sOp == null) {
  sOp = "";
}

int flowid = -1;
try {
  flowid = Integer.parseInt(fdFormData.getParameter("flowid"));
  session.setAttribute(Const.SESSION_ATTRIBUTE_FLOWID, flowid);
} catch(Exception e) {
  try {
    flowid = Integer.parseInt(session.getAttribute(Const.SESSION_ATTRIBUTE_FLOWID).toString());
  } catch(Exception ex) {
    session.setAttribute(Const.SESSION_ATTRIBUTE_FLOWID, -1);
  }
}

int pid = -1;
try {
  pid = Integer.parseInt(fdFormData.getParameter("pid"));
} catch(Exception e) {
  // Not advisable to store pid/subpid in session, so do nothing
}

int subpid = -1;
try {
  subpid = Integer.parseInt(fdFormData.getParameter("subpid"));
} catch(Exception e) {
  // Not advisable to store pid/subpid in session, so do nothing
}

String fromPageParameter = fdFormData.getParameter("show");
boolean fromPage = false;
if (fromPageParameter != null && !fromPageParameter.equals("") && "true".equals(fromPageParameter)){
  fromPage = true;
}
%>
<%@ include file = "../auth.jspf" %>
<%
Flow flow = BeanFactory.getFlowBean();

List<String> altmp = null;
List<String> altmp2 = null;
String sFlowHtml = "";

String sHtml = null;

if (sOp != null && sOp.equals("2") && sbError.length() == 0 && flowid > 0 && pid > 0 && subpid > 0) {
  ProcessData procData = pm.getProcessData(userInfo, flowid, pid, subpid, session);
  flow.hideProc(userInfo, procData, Integer.parseInt(sHidden));

  Logger.traceJsp(sPage, login + " hidden proc " + pid + " subproc " + subpid);
  if(sHidden.equals("1")){
	  sHtml = messages.getString("proc_hide.msg.hideSuccess");
  }else{
	  sHtml = messages.getString("proc_hide.msg.showSuccess");   
  }
  sHtml = sHtml.replace("{0}", "" + pid);
  sHtml = sHtml.replace("{1}", "" + subpid);
  sHtml = sHtml.replace("{2}", "\"" + flow.getFlow(userInfo, flowid).getName() + "\"");
  pid = -1;
  subpid = -1;
  flowid = -1;
}


if (flow != null) {
  
  IFlowData[] fda = BeanFactory.getFlowHolderBean().listFlows(userInfo);

  if (fda == null) fda = new IFlowData[0];

  altmp = new ArrayList<String>();
  altmp2 = new ArrayList<String>();

  altmp.add("-1");
  altmp2.add(sESCOLHA);

  for (int i=0; i < fda.length; i++) {
    altmp.add(String.valueOf(fda[i].getId()));
    altmp2.add(fda[i].getName());
  }

  sFlowHtml = Utils.genHtmlSelect("flowid",
				  sLocked,
				  "" + flowid,
				  altmp,
				  altmp2);
}


ListIterator<Activity> it = null;
//if (sCancel.equals("false") && sbError.length() == 0 && flowid > 0 && fromPage) {
if (sFirst.equals("false") && sbError.length() == 0 && flowid > 0) {
  it = pm.getProcessActivities(userInfo, flowid, pid, subpid);
}
%>


<form name="proccancel" method="POST">
  <input type="hidden" name="show" value="true" />

  <h1 id="title_admin"><%=title%></h1>
<% if (sbError.length() > 0) { %>
  <div class="error_msg">
    <%=sbError.toString()%>
  </div>
<% } %>

<% if (sHtml != null) { %>
  <div class="info_msg">
    <%=sHtml%>
  </div>
<% } %>

  <fieldset>
    <ol>
      <li>
        <label for="flowid"><%=messages.getString("proc_hide.field.flow")%></label>
        <%=sFlowHtml%>
      </li>
      <li>
        <label for="pid"><%=messages.getString("proc_hide.field.pid")%></label>
        <input type="text" name="pid" class="txt" value="<%=(pid > -1 ? pid : "") %>" size="10" maxlength="10" <%=sLocked%> />
      </li>
      <li>
        <label for="subpid"><%=messages.getString("proc_hide.field.subpid")%></label>
        <input type="text" name="subpid" class="txt" value="<%=(subpid > -1 ? subpid : "") %>" size="10" maxlength="10" <%=sLocked%>>
      </li>
    </ol>
  </fieldset>
  <fieldset class="submit">
  	 <input class="regular_button_00" type="button" name="show" value="<%=messages.getString("button.show")%>" onClick="javascript:tabber_right(4, '<%=response.encodeURL("Admin/ProcManagement/proc_hide.jsp") %>', get_params(document.proccancel));"/>
  </fieldset>
  
<% if (it != null && it.hasNext()) { %>
  <div class="table_inc">  
    <table class="item_list">
      <tr class="tab_header">
        <td><%=messages.getString("proc_hide.table.flow")%></td>
        <td><%=messages.getString("proc_hide.table.pnumber")%></td>
        <td><%=messages.getString("proc_hide.table.pid")%></td>
        <td><%=messages.getString("proc_hide.table.subpid")%></td>
        <td><%=messages.getString("proc_hide.table.creator")%></td>
        <td><%=messages.getString("proc_hide.table.user")%></td>
        <td />
      </tr>

      <%
        boolean toggle = false;
      	Activity a = null;
      	// assuring no repetition through this list
      	List<Activity> activities = new ArrayList<Activity>();
        while(it.hasNext()) {
          a = it.next();
          // check if list contains item
          boolean contains = false;
          for(Activity activity : activities) {
            if(a.flowid == activity.flowid
                && a.pid == activity.pid 
                && a.subpid == activity.subpid) {
              contains = true;
              break;
            }
          }
          if(!contains) {
            activities.add(a);
            ProcessData process = null;
            try {
              process = pm.getProcessData(userInfo, a.flowid, a.pid, a.subpid, session);
              String params = "flowid=" + a.flowid + "&pid=" + a.pid + "&subpid=" + a.subpid + "&ts=" + ts + "&show=true"+"&cancel=true";
              String hide = "javascript:" +
                  "if(confirm('" + messages.getString("proc_hide.msg.confirm") + "')) { " +
                    "tabber_right(4, '" +  response.encodeURL("Admin/ProcManagement/proc_hide.jsp") + "', '" + params + "&op=2&hide=1');"+
                  "};";
              String show = "javascript:" +
                  "tabber_right(4, '" +  response.encodeURL("Admin/ProcManagement/proc_hide.jsp") + "', '" + params + "&op=2&hide=0');"+
                  ";";
                  
              if(pid > -1 && subpid > -1) {
                params = "flowid=" + a.flowid + "&ts=" + ts+"&cancel=true";
              }
              String zoom = "javascript:tabber_right(4, '" + response.encodeURL("Admin/ProcManagement/proc_hide.jsp") + "', '" + params + "');";
              if (process != null) {
              	%><tr class="<%=(toggle=!toggle)?"tab_row_even":"tab_row_odd"%>">
					<td><a href="<%=zoom %>"><%=flow.getFlow(userInfo, process.getFlowId()).getName() %></a></td>
          <td><a href="<%=zoom %>"><%=process.getPNumber() %></a></td>
					<td><a href="<%=zoom %>"><%=process.getPid() %></a></td>
					<td><a href="<%=zoom %>"><%=process.getSubPid() %></a></td>
					<td><a href="<%=zoom %>"><%=process.getCreator() %></a></td>
					<td><a href="<%=zoom %>"><%=process.getCurrentUser() %></a></td>
					
					<%if (process.getHidden() == 0){ %>
						<td class="itemlist_icon">
							<a href="<%=hide %>"><img src="images/icon_online.png" border="0" title="<%=messages.getString("proc_hide.hide") %>" alt="<%=messages.getString("proc_hide.hide") %>" /></a>
						</td>
					<%} else { %>
						<td class="itemlist_icon">
							<a href="<%=show %>"><img src="images/icon_offline.png" border="0" title="<%=messages.getString("proc_hide.show") %>" alt="<%=messages.getString("proc_hide.show") %>" /></a>
						</td>
					<%} %>
				</tr><%
              }
            } catch (Exception e) {
              Logger.errorJsp(login, sPage, "get dataset exception: " + e.getMessage());
            }
          }
    	}
    %>
    </table>
  </div>
<% } %>
</form>

<if:generateHelpBox context="proc_hide"/>

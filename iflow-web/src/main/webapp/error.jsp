<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/core" prefix="c" %>
<%@ taglib uri="http://www.iknow.pt/jsp/jstl/iflow" prefix="if" %>
<%@ include file = "inc/defs.jsp" %>
<% 
String title = messages.getString("nopriv.title");
%>
<%@ include file = "inc/process_top.jspf" %>
<div class="alert alert-danger">
  <if:message string="error.generic"/>
</div>
<%@ include file = "inc/process_bottom.jspf" %>

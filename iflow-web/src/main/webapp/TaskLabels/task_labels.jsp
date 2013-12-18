<%@page import="pt.iflow.api.folder.Folder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" errorPage="/errorhandler.jsp"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/core" prefix="c"%>
<%@ taglib uri="http://www.iknow.pt/jsp/jstl/iflow" prefix="if"%>
<%@ include file="../inc/defs.jsp"%>

<%

	FolderManager fm = BeanFactory.getFolderManagerBean();

	//EDIT FOLDER
	String editfolder = fdFormData.getParameter("editfolder");
	if(editfolder!=null){
		  String editname = fdFormData.getParameter("editname");
		  String color = "#"+fdFormData.getParameter("color");
	
		  if(editfolder.equals("0"))
			  fm.createFolder(userInfo,editname,color);
		  else
		  	  fm.editFolder(userInfo,editfolder,editname,color);
	}

	List<Folder> folders = fm.getUserFolders(userInfo);
%>

<ul>
	<%for (Folder folder: folders) { %>
	<li>
		<a href="javascript:getJSP('main_content.jsp?filterfolder=<%= folder.getFolderid()%>');" class="lmenu"><%=folder.getName()%></a> 
		<canvas width="15" height="30" style="float: right; background:<%=folder.getColor()%>;">Your browser does not support the HTML5 canvas tag.</canvas>
	</li>
	<%}%>
</ul>
	
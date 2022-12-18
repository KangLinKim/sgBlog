<%@ page contentType="text/html; charset=utf-8"%>  
<%@ page language="java" import="java.sql.*,java.util.*,java.text.*" %> 
<% request.setCharacterEncoding("utf-8"); %>

<%@ include file="/connection/dbconn_database.jsp" %>

<%
	String subject = request.getParameter("subject");
	String content = request.getParameter("content");
	String owner = request.getParameter("owner");
	String writer = request.getParameter("writer");
	
	 int id = 1;
	 int pos = 0;
	 if (content.length()==1) 
		 content = content+" ";

	while ((pos = content.indexOf("\'", pos)) != -1) {
		String left = content.substring(0, pos);
		String right = content.substring(pos, content.length());
		content = left + "\'" + right;
		pos += 2;
	}

	java.util.Date yymmdd = new java.util.Date();
	SimpleDateFormat myformat = new SimpleDateFormat("yy-MM-d h:mm a");
	String ymd=myformat.format(yymmdd);
	
	String sql_posts = null;
	Statement st_posts = null;
	ResultSet rs_posts = null;
	int cnt = 0;

	
	try{
		st_posts = con_posts.createStatement();
		sql_posts = "select max(post_id) from posts";
		rs_posts = st_posts.executeQuery(sql_posts);
		if (!(rs_posts.next())) 
			id = 1;
		else {
			id = rs_posts.getInt(1) + 1 ;
			rs_posts.close();
		}       
		sql_posts = "insert into posts values (" + id + ", '" + writer + "', '" + subject + "', '" + content + "', now())" ;
		
		cnt = st_posts.executeUpdate(sql_posts); 
		
		st_posts.close();
		con_posts.close();
		
	} catch (SQLException e) {
		out.println(e);
	}
%>

<jsp:forward page="/project/front/details.jsp">
	<jsp:param name="owner" value="<%=owner %>" />
	<jsp:param name="writer" value="<%=writer %>" />
	<jsp:param name="post_id" value="<%=id %>" />
</jsp:forward>
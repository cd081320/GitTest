/*==============================
 * DBConn
 * - 데이터베이스 연결 전용 객체(singleton)
 * - 예외처리 throws
==============================*/

package com.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConn
{
	private static Connection dbConn = null;
	
	public static Connection getConnection() throws ClassNotFoundException, SQLException
	{
		if (dbConn == null)
		{
			String url = "jdbc:oracle:thin:@localhost:1521:xe";
			String user = "scott";
			String password = "tiger";
			
			Class.forName("oracle.jdbc.driver.OracleDriver");
			
			dbConn = DriverManager.getConnection(url, user, password);
		}
		return dbConn;
	}
	
	public static Connection getConnection(String url, String user, String password) throws ClassNotFoundException, SQLException
	{
		if (dbConn == null)
		{
			Class.forName("oracle.jdbc.driver.OracleDriver");
			
			dbConn = DriverManager.getConnection(url, user, password);
		}
		return dbConn;
	}
	
	public static void close() throws SQLException
	{
		if (dbConn != null)
		{
			if (!dbConn.isClosed())
			{
				dbConn.close();
			}
		}
		dbConn = null;
	}
}



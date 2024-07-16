package com.test;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.util.DBConn;

public class BoardDAO
{
	private Connection conn;
	
	public BoardDAO(Connection conn)
	{
		this.conn = conn;
	}
	
	// 게시물 번호의 최대값 얻어내기
	public int getMaxNum()
	{
		int result = 0;
		Statement stmt = null;
		ResultSet rs = null;
		String sql = "";
		
		try
		{
			sql = "SELECT NVL(MAX(NUM), 0) AS MAXNUM FROM TBL_BOARD";
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if (rs.next())
				result = rs.getInt("MAXNUM");
			rs.close();
			stmt.close();
			
		} catch (Exception e)
		{
			System.out.println(e.toString());
		}
		
		return result;
	}
	
	// 게시물 작성, 데이터 입력
	public int insertData(BoardDTO data)
	{
		int result = 0;
		PreparedStatement pstmt = null;
		String sql = "";
		
		try
		{
			sql = "INSERT INTO TBL_BOARD(NUM, NAME, PWD, EMAIL, SUBJECT, CONTENT, IPADDR) "
					+ "VALUES(?, ?, ?, ?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, data.getNum());
			pstmt.setString(2, data.getName());
			pstmt.setString(3, data.getPwd());
			pstmt.setString(4, data.getEmail());
			pstmt.setString(5, data.getSubject());
			pstmt.setString(6, data.getContent());
			pstmt.setString(7, data.getIpAddr());
			
			result = pstmt.executeUpdate();
			pstmt.close();
			
		} catch (Exception e)
		{
			System.out.println(e.toString());
		}
		
		return result;
	}
	
	// db 레코드의 갯수 가져오는 메소드(전체)
	
	/*
	 * public int getDataCount() { int result = 0; PreparedStatement pstmt = null;
	 * ResultSet rs = null; String sql = "";
	 * 
	 * try { sql = "SELECT COUNT(*) AS COUNT FROM TBL_BOARD"; pstmt =
	 * conn.prepareStatement(sql); rs = pstmt.executeQuery(); if (rs.next()) result
	 * = rs.getInt("COUNT"); rs.close(); pstmt.close();
	 * 
	 * } catch (Exception e) { System.out.println(e.toString()); }
	 * 
	 * return result; }
	 */
	 
	
	// 검색 기능 추가
	// searchKey : 제목, 작성자, 내용
	// searchValue : 입력 값
	public int getDataCount(String searchKey, String searchValue)
	{
		int result = 0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";

		try
		{
			sql = "SELECT COUNT(*) AS COUNT FROM TBL_BOARD WHERE " + searchKey + " LIKE ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%" + searchValue + "%");

			rs = pstmt.executeQuery();
			if (rs.next())
				result = rs.getInt("COUNT");

			rs.close();
			pstmt.close();

		} catch (Exception e)
		{
			System.out.println(e.toString());
		}
		return result;
	}
	 
	
	// 특정 영역의(시작번호 ~ 끝번호) 게시물의 목록을 읽어오는 메소드
	// 검색기능 추가시 수정
	/*
	 * public List<BoardDTO> getList(int start, int end) { List<BoardDTO> result =
	 * new ArrayList<BoardDTO>(); PreparedStatement pstmt = null; ResultSet rs =
	 * null; String sql = "";
	 * 
	 * try { sql = "SELECT NUM, NAME, SUBJECT, HITCOUNT, CREATED " +
	 * "FROM ( SELECT ROWNUM RNUM, DATA.* " +
	 * "FROM ( SELECT NUM, NAME, SUBJECT, HITCOUNT" +
	 * ", TO_CHAR(CREATED, 'YYYY-MM-DD') AS CREATED FROM TBL_BOARD ORDER BY NUM DESC ) DATA )"
	 * + " WHERE RNUM BETWEEN ? AND ?"; pstmt = conn.prepareStatement(sql);
	 * pstmt.setInt(1, start); pstmt.setInt(2, end); rs = pstmt.executeQuery();
	 * 
	 * while (rs.next()) { BoardDTO dto = new BoardDTO();
	 * dto.setNum(rs.getInt("NUM")); dto.setName(rs.getString("NAME"));
	 * dto.setSubject(rs.getString("SUBJECT"));
	 * dto.setHitCount(rs.getInt("HITCOUNT"));
	 * dto.setCreated(rs.getString("CREATED"));
	 * 
	 * result.add(dto); } rs.close(); pstmt.close();
	 * 
	 * } catch (Exception e) { System.out.println(e.toString()); }
	 * 
	 * return result; }
	 */
	
	// 검색 기능 추가
	public List<BoardDTO> getList(int start, int end, String searchKey, String searchValue)
	{
		List<BoardDTO> result = new ArrayList<BoardDTO>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";
		
		try
		{
			sql = "SELECT NUM, NAME, SUBJECT, HITCOUNT, CREATED"
					+ " FROM ( SELECT ROWNUM RNUM, DATA.*"
					+ " FROM ( SELECT NUM, NAME, SUBJECT, HITCOUNT, TO_CHAR(CREATED, 'YYYY-MM-DD') AS CREATED"
					+ " FROM TBL_BOARD WHERE " + searchKey + " LIKE ? ORDER BY NUM DESC )"
					+ " DATA )"
					+ " WHERE RNUM BETWEEN ? AND ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%" + searchValue + "%");
			pstmt.setInt(2, start);
			pstmt.setInt(3, end);
			
			rs = pstmt.executeQuery();
			
			while (rs.next())
			{
				BoardDTO dto = new BoardDTO();
				dto.setNum(rs.getInt("NUM"));
				dto.setName(rs.getString("NAME"));
				dto.setSubject(rs.getString("SUBJECT"));
				dto.setHitCount(rs.getInt("HITCOUNT"));
				dto.setCreated(rs.getString("CREATED"));
				
				result.add(dto);
			}
			
			rs.close();
			pstmt.close();
			
		} catch (Exception e)
		{
			System.out.println(e.toString());
		}
		
		return result;
	}
	
	// 특정 게시물 조회에 따른 조회 횟수 증가 메소드 정의
	public int updateHitCount(int num)
	{
		int result = 0;
		PreparedStatement pstmt = null;
		String sql = "";
		
		try
		{
			sql = "UPDATE TBL_BOARD SET HITCOUNT = HITCOUNT + 1 WHERE NUM=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			result = pstmt.executeUpdate();
			
			pstmt.close();
			
		} catch (Exception e)
		{
			System.out.println(e.toString());
		}
		
		return result;
	}
	
	
	// 특정 게시물의 내용을 읽어오는 메소드 정의
	public BoardDTO getReadData(int num)
	{
		BoardDTO result = new BoardDTO();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";
		
		try
		{
			sql = "SELECT NUM, NAME, PWD, EMAIL, SUBJECT, CONTENT, IPADDR, HITCOUNT"
					+ ", TO_CHAR(CREATED, 'YYYY-MM-DD') AS CREATED"
					+ " FROM TBL_BOARD WHERE NUM=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			if (rs.next())
			{
				result.setNum(rs.getInt("NUM"));
				result.setName(rs.getString("NAME"));
				result.setPwd(rs.getString("PWD"));
				result.setEmail(rs.getString("EMAIL"));
				result.setSubject(rs.getString("SUBJECT"));
				result.setContent(rs.getString("CONTENT"));
				result.setIpAddr(rs.getString("IPADDR"));
				result.setHitCount(rs.getInt("HITCOUNT"));
				result.setCreated(rs.getString("CREATED"));
			}
			
			rs.close();
			pstmt.close();
			
		} catch (Exception e)
		{
			System.out.println(e.toString());
		}
		
		return result;
	}
	
	// 특정 게시물의 이전 게시물 번호를 얻어내는 메소드 정의
	// 이전 게시물이 존재하지 않을 경우 -1
	public int getBeforeNum(int num)
	{
		int result = 0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";
		
		try
		{
			sql = "SELECT NVL(MAX(NUM), -1) AS PREVNUM FROM TBL_BOARD WHERE NUM<?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			if(rs.next())
				result = rs.getInt("PREVNUM");
			rs.close();
			pstmt.close();
			
			
		} catch (Exception e)
		{
			System.out.println(e.toString());
		}
		
		return result;
	}
	
	// 특정 게시물의 다음 게시물 번호를 얻어내는 메소드 정의
	// 이전 게시물이 존재하지 않을 경우 -1
	public int getNextNum(int num)
	{
		int result = 0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";
		
		try
		{
			sql = "SELECT NVL(MIN(NUM), -1) AS NEXTNUM FROM TBL_BOARD WHERE NUM>?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			if(rs.next())
				result = rs.getInt("NEXTNUM");
			rs.close();
			pstmt.close();
			
			
		} catch (Exception e)
		{
			System.out.println(e.toString());
		}
		
		return result;
	}
	
	// 특정 게시물의 내용을 수정하는 메소드
	public int updateData(BoardDTO dto)
	{
		int result = 0;
		PreparedStatement pstmt = null;
		String sql = "";
		
		try
		{
			sql = "UPDATE TBL_BOARD"
					+ " SET NAME=?, PWD=?, EMAIL=?, SUBJECT=?, CONTENT=? WHERE NUM = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getName());
			pstmt.setString(2, dto.getPwd());
			pstmt.setString(3, dto.getEmail());
			pstmt.setString(4, dto.getSubject());
			pstmt.setString(5, dto.getContent());
			pstmt.setInt(6, dto.getNum());
			
			result = pstmt.executeUpdate();
			
			pstmt.close();
			
		} catch (Exception e)
		{
			System.out.println(e.toString());
		}
		
		return result;
	}
	
	// 특정 게시물의 내용을 삭제하는 메소드
	public int deleteData(int num)
	{
		int result = 0;
		PreparedStatement pstmt = null;
		String sql = "";
		
		try
		{
			sql = "DELETE FROM TBL_BOARD WHERE NUM = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			
			result = pstmt.executeUpdate();
			
			pstmt.close();
			
		} catch (Exception e)
		{
			System.out.println(e.toString());
		}
		
		return result;
	}
}

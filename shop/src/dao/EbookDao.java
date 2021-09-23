package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import commons.DBUtil;
import vo.Ebook;

public class EbookDao {
	
	// 전체 전자책 목록 출력
	public ArrayList<Ebook> selectEbookList(int beginRow, int ROW_PER_PAGE) throws ClassNotFoundException, SQLException{
		/*
		 *  SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_state ebookState FROM ebook ORDER BY create_date DESC LIMit ? , ?
		 */
		// 리턴값
		ArrayList<Ebook> list = new ArrayList<>();
		// 매개변수 디버깅
		System.out.println(beginRow + "< EbookDao.selectEbookList param : geginRow");
		System.out.println(ROW_PER_PAGE + "< EbookDao.selectEbookList param : ROW_PER_PAGE");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_state ebookState FROM ebook ORDER BY create_date DESC LIMIT ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, ROW_PER_PAGE);
		// 디버깅
		System.out.println(stmt + " < EbookDao.selectEbookList stmt");
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Ebook ebook = new Ebook();
			ebook.setEbookNo(rs.getInt("ebookNo"));
			ebook.setCategoryName(rs.getString("categoryName"));
			ebook.setEbookTitle(rs.getString("ebookTitle"));
			ebook.setEbookState(rs.getString("ebookState"));
			list.add(ebook);
         }
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		
		return list;
	}
	
	// 특정 카테고리 전자책 출력
	public ArrayList<Ebook> selectEbookListByCategory(int beginRow, int ROW_PER_PAGE, String categoryName) throws ClassNotFoundException, SQLException{
		/*
		 *  SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_state ebookState FROM ebook WHERE category_name=? ORDER BY create_date DESC LIMit ? , ?
		 */
		ArrayList<Ebook> list = new ArrayList<>();
		// 매개변수 디버깅
		System.out.println(beginRow + "< EbookDao.selectEbookListByCategory param : geginRow");
		System.out.println(ROW_PER_PAGE + "< EbookDao.selectEbookListByCategory param : ROW_PER_PAGE");
		System.out.println(categoryName + "< EbookDao.selectEbookListByCategory param : categoryName");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_state ebookState FROM ebook WHERE category_name=? ORDER BY create_date DESC LIMIT ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, categoryName);
		stmt.setInt(2, beginRow);
		stmt.setInt(3, ROW_PER_PAGE);
		// 디버깅
		System.out.println(stmt + " < EbookDao.selectEbookListByCategory stmt");
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Ebook ebook = new Ebook();
			ebook.setEbookNo(rs.getInt("ebookNo"));
			ebook.setCategoryName(rs.getString("categoryName"));
			ebook.setEbookTitle(rs.getString("ebookTitle"));
			ebook.setEbookState(rs.getString("ebookState"));
			list.add(ebook);
         }
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		
		return list;
	}
	
	// [관리자] 전자책 목록의 특정 카테고리 페이지
		public int selectEbookListAllByCategoryNameTotalPage(String categoryName) throws ClassNotFoundException, SQLException {
			// 리턴값
			int totalCount = 0;
			// 매개변수 디버깅
			System.out.println(categoryName + "< EbookDao.selectEbookListAllByCategoryNameTotalPage param : categoryName");
			// DB연결 메서드 호출
			DBUtil dbUtil = new DBUtil();
			Connection conn = dbUtil.getConnection();
			// 쿼리문 생성
			String sql = "SELECT count(*) FROM ebook WHERE category_name=?";
			// 쿼리문 실행
			PreparedStatement stmt = conn.prepareStatement(sql);
			stmt.setString(1, categoryName);
			// 디버깅
			System.out.println(stmt + " < EbookDao.selectEbookListAllByCategoryNameTotalPage stmt");
			ResultSet rs = stmt.executeQuery();
			if(rs.next()) {
				totalCount = rs.getInt("count(*)");
			}
			// 자원 해제
			conn.close();
			stmt.close();
			rs.close();
			
			return totalCount;
		}
		
		// [관리자] 전자책 목록의 전체 페이지
		public int selectEbookListAllByTotalPage() throws ClassNotFoundException, SQLException {
			// 리턴값
			int totalCount = 0;
			// DB연결 메서드 호출
			DBUtil dbUtil = new DBUtil();
			Connection conn = dbUtil.getConnection();
			// 쿼리문 생성
			String sql = "SELECT count(*) FROM ebook ";
			// 쿼리문 실행
			PreparedStatement stmt = conn.prepareStatement(sql);
			// 디버깅
			System.out.println(stmt + " < EbookDao.selectEbookListAllByTotalPage stmt");
			ResultSet rs = stmt.executeQuery();
			if(rs.next()) {
				totalCount = rs.getInt("count(*)");
			}
			// 자원 해제
			conn.close();
			stmt.close();
			rs.close();
			
			return totalCount;
		}
		
		// [관리자] 전자책 목록의 마지막 페이지
		public int selectEbookListAllByLastPage(int totalCount, int ROW_PER_PAGE) throws ClassNotFoundException, SQLException {
			// 리턴값
			int lastPage = 0;
			// 매개변수 디버깅
			System.out.println(totalCount + "< EbookDao.selectEbookListAllByLastPage param : totalCount");
			System.out.println(ROW_PER_PAGE + "< EbookDao.selectEbookListAllByLastPage param : ROW_PER_PAGE");
			// 마지막 페이지
			// lastPage를 전체 행의 수와 한 페이지에 보여질 행의 수(rowPerPage)를 이용하여 구한다
			lastPage = totalCount / ROW_PER_PAGE;
			if(totalCount % ROW_PER_PAGE != 0) {
				lastPage+=1;
			}
			// 디버깅
			System.out.println(lastPage + " < EbookDao.selectEbookListAllByLastPage lastPage");
			
			return lastPage;
		}
}

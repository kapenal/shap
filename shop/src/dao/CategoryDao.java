package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.security.auth.message.callback.PrivateKeyCallback.Request;

import commons.DBUtil;
import vo.*;

public class CategoryDao {
	// [관리자] 카테고리 중복 검사
	public String selectCategoryCheck(String categoryCheckName) throws ClassNotFoundException, SQLException {
		// 리턴값
		String returncategoryName = null;
		// 매개변수 디버깅
		System.out.println(categoryCheckName + " < CategoryDao.selectCategoryCheck param : categoryName");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "SELECT category_name categoryName FROM category WHERE category_name=?";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, categoryCheckName);
		// 디버깅
		System.out.println(stmt + " < CategoryDao.selectCategoryCheck stmt");
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			returncategoryName = rs.getString("categoryName");
		}
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		
		// null이면 사용가능한 카테고리, null이 아니면 이미 존재하는 카테고리
		return returncategoryName;
	}

	// [관리자] 사용 여부 변경
	public void updateCategoryState(Category category) throws ClassNotFoundException, SQLException {
		// 매개변수 디버깅
		System.out.println(category.getCategoryName() + " < CategoryDao.updateCategoryState param : categoryName");
		System.out.println(category.getCategoryState() + " < CategoryDao.updateCategoryState param : categoryState");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "UPDATE category SET update_date=Now(), category_state=? WHERE category_name=?";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, category.getCategoryState());
		stmt.setString(2, category.getCategoryName());
		// 디버깅
		System.out.println(stmt + " < CategoryDao.updateCategoryState stmt");
		int row = stmt.executeUpdate();
		if(row == 1) {
			System.out.println("사용 여부 변경 성공");
			// 자원 해제
			stmt.close();
			conn.close();
			return;
		}
		System.out.println("사용 여부 변경 실패");
		// 자원 해제
		stmt.close();
		conn.close();
	}
	
	// [관리자] 카테고리 추가
	public void insertCategory(Category category) throws ClassNotFoundException, SQLException {
		// 매개변수 디버깅
		System.out.println(category.getCategoryName() + " < CategoryDao.insertCategory param : categoryName");
		System.out.println(category.getCategoryState() + " < CategoryDao.insertCategory param : categoryState");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "INSERT INTO category(category_name, update_date, create_date, category_state) VALUES(?,Now(),Now(),?)";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, category.getCategoryName());
		stmt.setString(2, category.getCategoryState());
		// 디버깅
		System.out.println(stmt + " < CategoryDao.insertCategory stmt");
		int row = stmt.executeUpdate();
		if(row == 1) {
			System.out.println("카테고리 추가 성공");
			// 자원 해제
			stmt.close();
			conn.close();
			return;
		}
		System.out.println("카테고리 추가 실패");
		// 자원 해제
		stmt.close();
		conn.close();
	}
	
	// [관리자] 카테고리 목록 출력
	public ArrayList<Category> selectCategoryList() throws ClassNotFoundException, SQLException {
		// 리턴값
		ArrayList<Category> categoryList = new ArrayList<Category>();
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "SELECT category_name categoryName, update_date updateDate, create_date createDate, category_state categoryState FROM category ORDER BY create_date DESC";
		PreparedStatement stmt = conn.prepareStatement(sql);
		// 디버깅
		System.out.println(stmt + " < CategoryDao.selectCategoryList stmt");
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Category category = new Category();
			category.setCategoryName(rs.getString("categoryName"));
			category.setUpdateDate(rs.getString("updateDate"));
			category.setCreatDate(rs.getString("createDate"));
			category.setCategoryState(rs.getString("categoryState"));
			categoryList.add(category);
	     }
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		
		return categoryList;
	}
}

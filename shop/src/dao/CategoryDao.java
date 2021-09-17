package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import commons.DBUtil;
import vo.*;

public class CategoryDao {
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
		System.out.println(stmt + " < memberDao.selectCategoryList stmt");
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

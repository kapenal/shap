package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import commons.DBUtil;
import vo.*;

public class QnaDao {
	// [고객] QnA 추가
	public void insertQna(Qna qna) throws ClassNotFoundException, SQLException {
		// 매개변수 디버깅
		System.out.println(qna.getQnaCategory() + " < QnaDao.insertQna param : qnaCategory");
		System.out.println(qna.getQnaTitle() + " < QnaDao.insertQna param : qnaTitle");
		System.out.println(qna.getQnaContent() + " < QnaDao.insertQna param : qnaContent");
		System.out.println(qna.getQnaSecret() + " < QnaDao.insertQna param : qnaSecret");
		System.out.println(qna.getMemberNo() + " < QnaDao.insertQna param : memberNo");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "INSERT INTO qna(qna_category, qna_title, qna_content, qna_secret, member_no, create_date, update_date) VALUES(?,?,?,?,?,Now(),Now())";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, qna.getQnaCategory());
		stmt.setString(2, qna.getQnaTitle());
		stmt.setString(3, qna.getQnaContent());
		stmt.setString(4, qna.getQnaSecret());
		stmt.setInt(5, qna.getMemberNo());
		// 디버깅
		System.out.println(stmt + " < QnaDao.insertQna stmt");
		int row = stmt.executeUpdate();
		if(row == 1) {
			System.out.println("QnA 작성 성공");
			// 자원 해제
			stmt.close();
			conn.close();
			return;
		}
		System.out.println("QnA 작성 실패");
		// 자원 해제
		stmt.close();
		conn.close();
	}
	
	// [관리자 & 고객 & 일반] QnA 상세보기
	public Qna selectQnaOne(int qnaNo) throws ClassNotFoundException, SQLException {
		// 리턴값
		Qna qna = null;
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 실행
		String sql = "SELECT qna_no qnaNo, qna_category qnaCategory, qna_title qnaTitle, qna_content qnaContent, qna_secret qnaSecret, member_no memberNo, create_date createDate, update_date updateDate  FROM qna WHERE qna_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qnaNo);
		System.out.println(stmt+ "< QnaDao.selectQnaOne stmt");
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			qna = new Qna();
			qna.setQnaNo(rs.getInt("qnaNo"));
			qna.setQnaCategory(rs.getString("qnaCategory"));
			qna.setQnaTitle(rs.getString("qnaTitle"));
			qna.setQnaContent(rs.getString("qnaContent"));
			qna.setQnaSecret(rs.getString("qnaSecret"));
			qna.setMemberNo(rs.getInt("memberNo"));
			qna.setCreateDate(rs.getString("createDate"));
			qna.setUpdateDate(rs.getString("updateDate"));
         }
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		
		return qna;
	}
	
	// [관리자 & 고객 & 일반] QnA게시판의 마지막 페이지
	public int selectQnaListAllByLastPage(int totalCount, int ROW_PER_PAGE) throws ClassNotFoundException, SQLException {
		// 리턴값
		int lastPage = 0;
		// 매개변수 디버깅
		System.out.println(totalCount + "< QnaDao.selectQnaListAllByLastPage param : totalCount");
		System.out.println(ROW_PER_PAGE + "< QnaDao.selectQnaListAllByLastPage param : ROW_PER_PAGE");
		// 마지막 페이지
		// lastPage를 전체 행의 수와 한 페이지에 보여질 행의 수(rowPerPage)를 이용하여 구한다
		lastPage = totalCount / ROW_PER_PAGE;
		if(totalCount % ROW_PER_PAGE != 0) {
			lastPage+=1;
		}
		// 디버깅
		System.out.println(lastPage + " < QnaDao.selectQnaListAllByLastPage lastPage");
		return lastPage;
	}
	
	// [관리자 & 고객 & 일반] 전체 QnA 페이지
	public int selectQnaListAllByTotalPage() throws ClassNotFoundException, SQLException {
		// 리턴값
		int totalCount = 0;
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "SELECT count(*) FROM qna ";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);	
		// 디버깅
		System.out.println(stmt + " < QnaDao.selectQnaListAllByTotalPage stmt");
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
	
	// [관리자 & 고객 & 일반] 전체 QnA게시판 출력
	public ArrayList<Qna> selectQnaList(int beginRow, int ROW_PER_PAGE) throws ClassNotFoundException, SQLException{
		// 리턴값
		ArrayList<Qna> list = new ArrayList<>();
		// 매개변수 디버깅
		System.out.println(beginRow + "< QnaDao.selectQnaList param : bgeginRow");
		System.out.println(ROW_PER_PAGE + "< QnaDao.selectQnaList param : ROW_PER_PAGE");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 실행
		String sql = "SELECT qna_no qnaNo, qna_category qnaCategory, qna_title qnaTitle, qna_content qnaContent, qna_secret qnaSecret, member_no memberNo, create_date createDate, update_date updateDate  FROM qna ORDER BY create_date DESC LIMIT ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, ROW_PER_PAGE);
		// 디버깅
		System.out.println(stmt + " < QnaDao.selectQnaList stmt");
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Qna qna = new Qna();
			qna.setQnaNo(rs.getInt("qnaNo"));
			qna.setQnaCategory(rs.getString("qnaCategory"));
			qna.setQnaTitle(rs.getString("qnaTitle"));
			qna.setQnaContent(rs.getString("qnaContent"));
			qna.setQnaSecret(rs.getString("qnaSecret"));
			qna.setMemberNo(rs.getInt("memberNo"));
			qna.setCreateDate(rs.getString("createDate"));
			qna.setUpdateDate(rs.getString("updateDate"));
			list.add(qna);
         }
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		
		return list;
	}
}

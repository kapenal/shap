package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import commons.DBUtil;
import vo.*;

public class QnaCommentDao {
	// [작성자] QnA 삭제 시 답글도 삭제
	public void deleteQnaComment(int qnaNo) throws ClassNotFoundException, SQLException {
		// 매개변수 디버깅
		System.out.println(qnaNo + " < QnaCommentDao.deleteQnaComment param : qnaNo");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "DELETE FROM qna_comment WHERE qna_no=?";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qnaNo);
		// 디버깅
		System.out.println(stmt + " < QnaCommentDao.deleteQnaComment stmt");
		int row = stmt.executeUpdate();
		if(row == 1) {
			System.out.println("QnA 답글 삭제 완료");
		}
		//자원 해제
		conn.close();
		stmt.close();
	}
	// [관리자] QnA 답글 입력
	public void insertQnaComment(QnaComment qnaComment) throws ClassNotFoundException, SQLException {
		// 매개변수 디버깅
		System.out.println(qnaComment.getQnaNo() + " < QnaCommentDao.insertQnaComment param : qnaNo");
		System.out.println(qnaComment.getQnaCommentContent() + " < QnaCommentDao.insertQnaComment param : qnaCommentContent");
		System.out.println(qnaComment.getMemberNo() + " < QnaCommentDao.insertQnaComment param : memberNo");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성
		String sql = "INSERT INTO qna_comment(qna_no, qna_comment_content, member_no, create_date, update_date) VALUES(?,?,?,Now(),Now())";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qnaComment.getQnaNo());
		stmt.setString(2, qnaComment.getQnaCommentContent());
		stmt.setInt(3, qnaComment.getMemberNo());
		// 디버깅
		System.out.println(stmt + " < QnaCommentDao.insertQnaComment stmt");
		int row = stmt.executeUpdate();
		if(row == 1) {
			System.out.println("답글 작성 성공");
			// 자원 해제
			stmt.close();
			conn.close();
			return;
		}
		System.out.println("답글 작성 실패");
		// 자원 해제
		stmt.close();
		conn.close();
	}
	// 답글 중복 방지
	public int qnaCommentCheck(int qnaNo) throws ClassNotFoundException, SQLException {
		// 리턴값
		int row = 0;
		// 매개변수 디버깅
		System.out.println(qnaNo + "< QnaCommentDao.qnaCommentCheck param : qnaNo");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 생성, 이미 있는 후기인지 찾는 sql문
		String sql = "SELECT qna_no FROM qna_comment WHERE qna_no=?";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qnaNo);
		// 디버깅
		System.out.println(stmt + " < QnaCommentDao.qnaCommentCheck stmt");
		ResultSet rs = stmt.executeQuery();
		// 이미 입력된 후기가 있는지 확인하는 if문
		if(rs.next()) {
			row = 1;
		}
		System.out.println(row);
		// 자원 해제
		conn.close();
		stmt.close();
		rs.close();
		return row;
	}
	
	// [관리자 & 고객 & 일반 ] 답글 출력
	public QnaComment selectQnaComment(int qnaNo) throws ClassNotFoundException, SQLException {
		// 리턴값
		QnaComment qnaComment = null;
		// 매개변수 디버깅
		System.out.println(qnaNo + " < QnaCommentDao.selectQnaComment param : qnaNo");
		// DB연결 메서드 호출
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
		String sql = "SELECT qna_no qnaNo, qna_comment_content qnaCommentContent, member_no memberNo, create_date createDate, update_date updateDate FROM qna_comment WHERE qna_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qnaNo);
		System.out.println(stmt + " < QnaCommentDao.selectQnaCommentList stmt");
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			qnaComment = new QnaComment();
			qnaComment.setQnaNo(rs.getInt("qnaNo"));
			qnaComment.setQnaCommentContent(rs.getString("qnaCommentContent"));
			qnaComment.setMemberNo(rs.getInt("memberNo"));
			qnaComment.setCreateDate(rs.getString("createDate"));
		}
		// 자원 해제
		stmt.close();
		conn.close();
		rs.close();
		return qnaComment;
	}
}

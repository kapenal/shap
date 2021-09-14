package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import commons.DBUtil;
import vo.Member;

public class MemberDao {
	public void insertMember(Member member) throws ClassNotFoundException, SQLException {
		// 매개변수 디버깅
		System.out.println(member.getMemberId() + "< MemberDao.insertMember param : memberId");
		System.out.println(member.getMemberPw() + "< MemberDao.insertMember param : memberPw");
		System.out.println(member.getMemberName() + "< MemberDao.insertMember param : memberName");
		System.out.println(member.getMemberAge() + "< MemberDao.insertMember param : memberAge");
		System.out.println(member.getMemberGender() + "< MemberDao.insertMember param : memberGender");
		// DB연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 설정
		String sql = "INSERT INTO member( member_id, member_pw, member_level, member_name, member_age, member_gender, update_date, create_date) Values(?,PASSWORD(?),0,?,?,?,NOW(),NOW())";
		// 쿼리 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, member.getMemberId());
		stmt.setString(2, member.getMemberPw());
		stmt.setString(3, member.getMemberName());
		stmt.setInt(4, member.getMemberAge());
		stmt.setString(5, member.getMemberGender());
		// 디버깅
		System.out.println(stmt + " < MemberDao.insertMember stmt");
		int row = stmt.executeUpdate();
		if(row == 1) {
			System.out.println("회원가입 성공");
			// 자원 해제
			stmt.close();
			conn.close();
			return;
		}
		// 자원 해제
		stmt.close();
		conn.close();
		System.out.println("회원가입 실패");
	}
	
	public Member login(Member member) throws ClassNotFoundException, SQLException {
		// 리턴값
		Member returnMember = null;
		// 매개변수 디버깅
		System.out.println(member.getMemberId() + "< MemberDao.login param : memberId");
		System.out.println(member.getMemberPw() + "< MemberDao.login param : memberPw");
		// DB연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// 쿼리문 설정
		String sql = "SELECT member_no memberNo, member_id memberId, member_name memberName, member_level memberLevel FROM member WHERE member_id=? AND member_pw=PASSWORD(?)";
		// 쿼리문 실행
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, member.getMemberId());
		stmt.setString(2, member.getMemberPw());
		// 디버깅
		System.out.println(stmt + " < MemberDao.login stmt");
		ResultSet rs = stmt.executeQuery();
		System.out.println(rs + " < MemberDao.login rs");
		if(rs.next()) {
			returnMember = new Member();
			returnMember.setMemberNo(rs.getInt("memberNo"));
			returnMember.setMemberId(rs.getString("memberId"));
			returnMember.setMemberName(rs.getString("memberName"));
			returnMember.setMemberLevel(rs.getInt("memberLevel"));
			System.out.println("로그인 성공");
			// 자원 해제
			stmt.close();
			conn.close();
			rs.close();
			return returnMember;
		}
		// 자원 해제
		stmt.close();
		conn.close();
		rs.close();
		System.out.println("로그인 실패");
		return null;
	}
}

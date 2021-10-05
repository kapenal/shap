package vo;

public class Qna {
	private int qnaNo;
	private String qnaCategory;
	private String qnaTitle;
	private String qnaContent;
	private String qnaSecret;
	private int memberNo;
	private String memberName;
	private String createDate;
	private String updateDate;
	
	public int getQnaNo() {
		return qnaNo;
	}
	public void setQnaNo(int qnaNo) {
		this.qnaNo = qnaNo;
	}
	public String getQnaCategory() {
		return qnaCategory;
	}
	public void setQnaCategory(String qnaCategory) {
		this.qnaCategory = qnaCategory;
	}
	public String getQnaTitle() {
		return qnaTitle;
	}
	public void setQnaTitle(String qnaTitle) {
		this.qnaTitle = qnaTitle;
	}
	public String getQnaContent() {
		return qnaContent;
	}
	public void setQnaContent(String qnaContent) {
		this.qnaContent = qnaContent;
	}
	public String getQnaSecret() {
		return qnaSecret;
	}
	public void setQnaSecret(String qnaSecret) {
		this.qnaSecret = qnaSecret;
	}
	public int getMemberNo() {
		return memberNo;
	}
	public void setMemberNo(int memberNo) {
		this.memberNo = memberNo;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public String getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}
	public String getMemberName() {
		return memberName;
	}
	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}
	@Override
	public String toString() {
		return "Qna [qnaNo=" + qnaNo + ", qnaCategory=" + qnaCategory + ", qnaTitle=" + qnaTitle + ", qnaContent="
				+ qnaContent + ", qnaSecret=" + qnaSecret + ", memberNo=" + memberNo + ", createDate=" + createDate
				+ ", updateDate=" + updateDate + "]";
	}
}

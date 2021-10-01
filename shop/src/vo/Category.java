package vo;
public class Category {
	private String categoryName;
	private String updateDate;
	private String creatDate;
	private String categoryState;
	
	public String getCategoryName() {
		return categoryName;
	}
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
	public String getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}
	public String getCreatDate() {
		return creatDate;
	}
	public void setCreatDate(String creatDate) {
		this.creatDate = creatDate;
	}
	public String getCategoryState() {
		return categoryState;
	}
	public void setCategoryState(String categoryState) {
		this.categoryState = categoryState;
	}
	@Override
	public String toString() {
		return "Category [categoryName=" + categoryName + ", updateDate=" + updateDate + ", creatDate=" + creatDate
				+ ", categoryState=" + categoryState + "]";
	}
}

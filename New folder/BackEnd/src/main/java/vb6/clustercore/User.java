package vb6.clustercore;

import javax.persistence.*;

@Entity
@Table(name = "Users")
public class User {
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Integer id;
	
	@Column(unique=true)
	private String username;
	
	private String authkey;
	private String token;
	private String info;
	
	@Column(unique=true)
	private String email;
	
	public Integer getId() {
		return id;
	}
	
	public String getUsername() {
		return username;
	}
	
	public void setUsername(String username) {
		this.username = username;
	}
	
	public String getAuthkey() {
		return authkey;
	}
	
	public void setAuthkey(String password) {
		this.authkey = password;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}
	
	public String getInfo() {
		return info;
	}
	
	public void setInfo(String info) {
		this.info = info;
	}
}

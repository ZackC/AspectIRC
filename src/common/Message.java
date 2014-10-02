package common;




import java.io.Serializable;


/**
 * serializable message that can be send over the sockets between client and
 * server. 
 */
public class Message implements Serializable, GeneralMessageType{

	private static final long serialVersionUID = -9161595018411902079L;
	private String content;
	private String header;

	public Message(String header, String content) {
		super();
		this.header = header;
		this.content = content;
	}

	public String getHeader() {
		return this.header;
	}
	
	public String getContent() {
		return content;
	}

	@Override
	public void setHeader(String newHeader) {
		this.header = newHeader;
		
	}
}

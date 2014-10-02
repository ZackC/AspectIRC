package aspects.reverseEncryption;

import javax.swing.JCheckBox;

import client.Client;
import client.OptionsPanel;

import common.Message;
import java.awt.LayoutManager;

public aspect ReverseEncryptionAspect {
JCheckBox reverseEncyrptionCheckBox = null;
	
	
	after(OptionsPanel op): this(op)  && call(public void setLayout(LayoutManager)) {
		reverseEncyrptionCheckBox = new JCheckBox("reverse encryption:");
		op.add(reverseEncyrptionCheckBox);
	}
	
	void around(Client c, Message msg): this(c) && execution(public void send(Message)) && args(msg){
	if (reverseEncyrptionCheckBox != null && reverseEncyrptionCheckBox.isSelected()) {
			System.out.println("adding reverse encyryption");
			String oldHeader = msg.getHeader();
			String newHeader;
			if (oldHeader == null || oldHeader.trim() == "") {
				newHeader =  "reverse";
			} else {
				newHeader = "reverse, " + oldHeader;
			}
			
			msg = new Message(newHeader,alterString(msg.getContent().toLowerCase()));
			System.out.println("reverse encrypted message: "
					+ msg.getContent());
			System.out
					.println("reverse encrypted header: " + msg.getHeader());
			//return resultMessage;
		} else {
			System.out.println("not using reverse encryption");
			//return msg;
		}
	    proceed(c, msg);
	}
	
	private static String alterString(String message) {
		return (new StringBuilder(message).reverse().toString());
	}
	
	void around(Client c, Object msg): this(c) && execution(protected void handleIncomingMessage(Object)) && args(msg){
		if (msg instanceof Message){
			Message msg1 = (Message)msg;
		String header = msg1.getHeader();
		int headerPos = header.indexOf("reverse");
		if (headerPos != -1){
	        	System.out.println("reverse header recieved: " + msg1.getHeader());
	        	System.out.println("reverse content: "+msg1.getContent());
	        
			
				if (msg1.getHeader().length() > headerPos+7) {
					System.out.println("found reverse answers");
					header = header.substring(0,headerPos)+header.substring(headerPos+7); 
				}																			
					String content = alterString(msg1.getContent());
					//return (new Message(header, content));
					msg = new Message(header, content);
				}
			  
		}
	        proceed(c,msg);
	}
}

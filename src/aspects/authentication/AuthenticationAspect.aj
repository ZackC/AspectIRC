package aspects.authentication;

import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JTextField;

public aspect AuthenticationAspect {
	
	String password;
	
  pointcut serverAuthetication():
  	call(ServerSocket(int));
  
  pointcut clientAuthentication():
  	call(ObjectInputStream(InputStream));
  
  after(): serverAutentication(){
  	JFrame frame = new JFrame("Enter Client Password");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.getContentPane().setLayout(new FlowLayout());
		frame.getContentPane().add(new JLabel("Enter Client's password"));
		final JTextField passwordField = new JTextField();
		passwordField.setPreferredSize(new Dimension(100, 30));
		;
		frame.getContentPane().add(passwordField);
		passwordField.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent evt) {
				if (evt.getKeyCode() == KeyEvent.VK_ENTER) {
					if (!passwordField.getText().trim().equals("")) {
						password = passwordField.getText();
						passwordField.setText("");
					}
				}
			}
		});
		frame.setSize(300, 40);
		frame.pack();
		frame.setVisible(true);
		while (password == null) {
			try {
				Thread.sleep(500);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		frame.setVisible(false);
		frame.dispose();
  }
}

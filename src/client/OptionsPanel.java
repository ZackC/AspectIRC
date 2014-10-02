package client;

import java.awt.Panel;

import javax.swing.BoxLayout;
import javax.swing.JCheckBox;
import javax.swing.JComboBox;

public class OptionsPanel extends Panel {

	JComboBox fontColor;
	JComboBox backgroundColor;
	JCheckBox reverseEncryptionCheckBox;
	JCheckBox rot13EncyrptionCheckBox;
	Gui g;

	public OptionsPanel(Gui g) {
		this.g = g;
		this.setLayout(new BoxLayout(this, BoxLayout.PAGE_AXIS));
		/*
		 * for (PlugInInterface pi : g.getClient().plugIns) {
		 * pi.drawSelectionOption(this, g.getTextArea()); }*? /* String[]
		 * selectableColors = {"black","white","red","green","blue"}; fontColor
		 * = new JComboBox(selectableColors); backgroundColor = new
		 * JComboBox(selectableColors); fontColor.setSelectedIndex(0);
		 * backgroundColor.setSelectedIndex(1); Panel fontColorPanel = new
		 * Panel(); fontColorPanel.setLayout(new FlowLayout());
		 * fontColorPanel.add(new JLabel("Font Color:"));
		 * fontColorPanel.add(fontColor); Panel backgroundColorPanel = new
		 * Panel(); backgroundColorPanel.setLayout(new FlowLayout());
		 * backgroundColorPanel.add(new JLabel("Background Color:"));
		 * backgroundColorPanel.add(backgroundColor); reverseEncryptionCheckBox
		 * = new JCheckBox("reverse encryption"); rot13EncyrptionCheckBox = new
		 * JCheckBox("rot13 encryption:"); this.add(fontColorPanel);
		 * this.add(backgroundColorPanel); this.add(reverseEncryptionCheckBox);
		 * this.add(rot13EncyrptionCheckBox);
		 */

	}

	public String[] getOptionsSelected() {
		String[] results = new String[4];
		results[0] = (String) fontColor.getSelectedItem();
		results[1] = (String) backgroundColor.getSelectedItem();
		return results;
	}
}

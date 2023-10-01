package util;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;

import javax.swing.JButton;

public class SpecialButton extends JButton {

  private Color color;
  private Color borderColor;
  private int radius = 0;

  public Color getColor() {
    return color;
  }

  public void setColor(Color color) {
    this.color = color;
    setBackground(color);
  }

  public Color getBorderColor() {
    return borderColor;
  }

  public void setBorderColor(Color borderColor) {
    this.borderColor = borderColor;
  }

  public int getRadius() {
    return radius;
  }

  public void setRadius(int radius) {
    this.radius = radius;
  }

  public SpecialButton(int radius, Color color, Color borderColor) {
    this.radius = radius;
    setColor(color);
    setBorderColor(borderColor);
    setContentAreaFilled(false);
  }

  public SpecialButton(int radius) {
    this.radius = radius;
  }

  @Override
  protected void paintComponent(Graphics grphcs) {
    Graphics2D g2 = (Graphics2D) grphcs;
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
    g2.setColor(borderColor);
    g2.fillRoundRect(0, 0, getWidth(), getHeight(), radius, radius);
    g2.setColor(getBackground());
    g2.fillRoundRect(2, 2, getWidth() - 4, getHeight() - 4, radius, radius);
    super.paintComponent(grphcs);
  }

}

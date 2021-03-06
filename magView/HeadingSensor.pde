/*  Copyright (C) 2014  Adam Green (https://github.com/adamgreen)

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
*/
class HeadingSensor
{
  HeadingSensor(Serial port, Heading min, Heading max)
  {
    calibrate(min, max);
    
    // Clear out any data that we might be in the middle of.
    m_port = port;
    m_port.clear();
    String dummy = m_port.readStringUntil('\n');
    m_port.bufferUntil('\n');
  }

  void calibrate(Heading min, Heading max)
  {
    m_midpoint = new FloatHeading((min.m_accelX + max.m_accelX) / 2.0f,
                                  (min.m_accelY + max.m_accelY) / 2.0f,
                                  (min.m_accelZ + max.m_accelZ) / 2.0f,
                                  (min.m_magX + max.m_magX) / 2.0f,
                                  (min.m_magY + max.m_magY) / 2.0f,
                                  (min.m_magZ + max.m_magZ) / 2.0f);
    m_scale = new FloatHeading((max.m_accelX - min.m_accelX) / 2.0f,
                               (max.m_accelY - min.m_accelY) / 2.0f,
                               (max.m_accelZ - min.m_accelZ) / 2.0f,
                               (max.m_magX - min.m_magX) / 2.0f,
                               (max.m_magY - min.m_magY) / 2.0f,
                               (max.m_magZ - min.m_magZ) / 2.0f);
  }

  void update()
  {
    String line = m_port.readString();
    if (line == null)
      return;
      
    String[] tokens = splitTokens(line, ",\n");
    if (tokens.length == 10)
    {
      m_currentRaw.m_accelX = int(tokens[0]);
      m_currentRaw.m_accelY = int(tokens[1]);
      m_currentRaw.m_accelZ = int(tokens[2]);
      m_currentRaw.m_magX = int(tokens[3]);
      m_currentRaw.m_magY = int(tokens[4]);
      m_currentRaw.m_magZ = int(tokens[5]);
   
      m_max = m_max.max(m_currentRaw);
      m_min = m_min.min(m_currentRaw);
    }
  }
    
  Heading getCurrentRaw()
  {
    return m_currentRaw;
  }
  
  FloatHeading getCurrent()
  {
    return new FloatHeading((m_currentRaw.m_accelX - m_midpoint.m_accelX) / m_scale.m_accelX,
                            (m_currentRaw.m_accelY - m_midpoint.m_accelY) / m_scale.m_accelY,
                            (m_currentRaw.m_accelZ - m_midpoint.m_accelZ) / m_scale.m_accelZ,
                            (m_currentRaw.m_magX - m_midpoint.m_magX) / m_scale.m_magX,
                            (m_currentRaw.m_magY - m_midpoint.m_magY) / m_scale.m_magY,
                            (m_currentRaw.m_magZ - m_midpoint.m_magZ) / m_scale.m_magZ);
  }
  
  Heading getMin()
  {
    return m_min;
  }
  
  Heading getMax()
  {
    return m_max;
  }
  
  Serial  m_port;
  Heading m_currentRaw = new Heading();
  Heading m_min = new Heading(0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF,
                              0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF);
  Heading m_max = new Heading(0x80000000, 0x80000000, 0x80000000,
                              0x80000000, 0x80000000, 0x80000000);
  FloatHeading m_midpoint;
  FloatHeading m_scale;
};


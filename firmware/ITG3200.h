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
#ifndef ITG3200_H_
#define ITG3200_H_

#include <mbed.h>
#include "Int16Vector.h"
#include "SensorBase.h"


class ITG3200 : public SensorBase
{
public:
    ITG3200(I2C* pI2C, int address = 0xD0);

    Int16Vector getVector();

protected:
    void initGyro();
    void waitForPllReady();
    void waitForDataReady();
};

#endif /* ITG3200_H_ */
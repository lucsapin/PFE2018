// Copyright (C) 2011 INRIA.
// All Rights Reserved.
// This code is published under the Eclipse Public License
// File: tools.hpp
// Authors: Vincent Grelard, Pierre Martinon, Olivier Tissot

#ifndef TOOLS_H
#define TOOLS_H

#include <iostream>
#include <string>
#include <fstream>
#include <sstream>
#include <vector>
#include <cmath>

void skip_comments(std::istream&, std::streampos);
void write_def_file(const std::string, const std::string, const std::string);

#endif


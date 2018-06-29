// Copyright (C) 2011 INRIA.
// All Rights Reserved.
// This code is published under the Eclipse Public License
// File: tools.cpp
// Authors: Vincent Grelard, Pierre Martinon, Olivier Tissot

#include <tools.hpp>
#include <cstdlib>

using namespace std;

/**
 * \fn void skip_comments(istream& file, streampos pos_init)
 *
 * This function ignores the commented and empty lines while reading a file.
 * It starts from the current position and skip to the next non commented line.
 * Comment symbol in Bocop file is "#".
 *
 */
void skip_comments(istream& file, streampos pos_init)
{
    string line = ""; // trash variable for the line
    string comment = "#"; // Sign declaring a comment line
    size_t found;

    file.seekg(pos_init, ios::beg);

    streampos pos_fin;
    pos_fin = file.tellg();

    file >> line;

    // We now seek if the line contains the comment character
    // "find" returns the position of the occurrence in the string of the searched content.
    // If the content is not found, the member value "npos" is returned.
    found = line.find(comment);

    while (found != string::npos) {
        // if the first line is a comment
        getline(file, line); // we read the whole line
        pos_fin = file.tellg();
        file >> line;
        found = line.find(comment);
    }
    file.seekg(pos_fin, ios::beg);
}

/**
 * \fn void write_def_file(const string name, const string type, const string value)
 *
 * This function writes the value named "name", of type "type" in the defintion file "problem.def".
 *
 */
void write_def_file(const string name, const string type, const string value)
{
    int index = -1; // Index of the line to write

    vector<string> all_text;
    string line;

    string name_f_def;
    name_f_def = "problem.def";

    ifstream file_def;
    file_def.open(name_f_def.c_str(), ios::in | ios::binary);
    if (!file_def) // if the opening failed
        throw "Cannot open problem.def to write the new value.";

    // Now we read the whole file, storing it into a string vector :
    try {
        while (getline(file_def, line))
            all_text.push_back(line);
    } catch (...) {
        throw "failed to read the whole problem.def file.";
    }

    file_def.close();

    // Now we have check if the line about parameter "name" is already written
    size_t found_name;
    size_t found_comment;
    for (unsigned int i = 0; i < all_text.size(); ++i) {
        cout << "all_text[" << i << "] = " << all_text[i] << endl;
        found_name = all_text.at(i).find(name + " ");
        if (found_name != string::npos) { // if the name was found
            found_comment = all_text[i].find("#");
            if (found_comment > found_name) { // we check that the line is not commented
                index = (int) i;
                break;
            }
        }
    }

    // We concatenate the strings to create the new line we wish to write :
    string newline;
    newline = name + " " + type + " " + value;

    // if the name was not found, we write it at the end, else we overwrite
    // the matching line :
    if (index < 0)
        all_text.push_back(newline);
    else
        all_text.at(index) = newline;


    // Now we can write the new value in the file :
    try {

        FILE* file_def_w;
        file_def_w = fopen("problem.def", "wb");
        for (unsigned int i = 0; i < all_text.size(); i++)
            fprintf(file_def_w, "%s\n", all_text[i].c_str());

        fclose(file_def_w);
    } catch (...) {
        throw "cannot write file problem.def.";
    }
}

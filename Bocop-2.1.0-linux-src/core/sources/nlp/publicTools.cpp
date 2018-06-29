// This code is published under the Eclipse Public License
// File: publicTools.hpp
// Authors: Jinyan Liu, Pierre Martinon, Olivier Tissot
// Inria Saclay and CMAP Ecole Polytechnique
// 2011-2017

#include <publicTools.hpp>

/**
 * \fn std::istream& safeGetLine(istream& is, string& str)
 *
 * Safer getline to handle end line from other OS than the current one.
 *
 */
istream& safeGetLine(istream& is, string& str)
{
   str.clear();

   // The characters in the stream are read one-by-one using a std::streambuf.
   // That is faster than reading them one-by-one using the std::istream.
   // Code that uses streambuf this way must be guarded by a sentry object.
   // The sentry object performs various tasks,
   // such as thread synchronization and updating the stream state.

   istream::sentry se(is, true);
   streambuf* sb = is.rdbuf();

   for(;;) {
      int c = sb->sbumpc();
      switch (c) {
      case '\n':
         return is;
      case '\r':
         if(sb->sgetc() == '\n')
            sb->sbumpc();
         return is;
      case EOF:
         // Also handle the case when the last line has no line ending
         if(str.empty())
            is.setstate(ios::eofbit);
         return is;
      default:
         str += (char)c;
      }
   }
}


// class for a row to be read from a CSV file
CSVRow::CSVRow(const char separator):m_separator(separator) {}
string const& CSVRow::operator[](size_t index) const {
   return m_data[index];
}
size_t CSVRow::size() const {
   return m_data.size();
}
void CSVRow::readNextRow(istream& str) {
   string line;
   // To handle files from an other OS
   safeGetLine(str,line);

   stringstream lineStream(line);
   string cell;

   m_data.clear();
   while(getline(lineStream,cell,m_separator))
      m_data.push_back(cell);
}

/**
 * \fn std::istream& operator>>(istream& str,CSVRow& data)
 *
 * Overload of operator>> for our little class CSVRow.
 *
 */
istream& operator>>(istream& str,CSVRow& data) {
   data.readNextRow(str);
   return str;
}

int readFileToVector(const string filename, vector<double> &v, const int verbose)
{
   double read_value;
   if (verbose > 0)
      cout << "Start reading data file... " << filename << endl;
   try {
      ifstream mydatafile(filename.data());
      // We check that the file has been found
      if(! mydatafile)
         throw string("Error: readFileToVector >>> cannot open file " + filename);
      // We read the file until the end of file
      while (mydatafile >> read_value)
         v.push_back(read_value);
      // We close the file
      mydatafile.close();
   } catch (string const& error) {
      // We exit if the file was not found
      cerr << error << endl;
      exit(-1);
   }
   // We print some information on the data
   if (verbose > 0)
      cout << "Range: " << v[0] << " | " << v[v.size()-1] << " Size: " << v.size() << endl;
   return (int) v.size();
}


int readCVSToMatrix(const string filename, vector<vector<double> > &v, const char separator, const int headersRows, const int verbose)
{
   CSVRow row(separator);
   cout << "Start reading csv file... " << filename << endl;
   try {
      ifstream mydatafile(filename.data());
      // We check that the file has been found
      if(! mydatafile)
         throw string("Error: readCVSToMatrix >>> cannot open file " + filename);

      // skip header
      string header;
      for (int i=0; i<headersRows; i++)
         getline(mydatafile,header);

      // read rows
      while (mydatafile >> row)
      {
         if(row.size() > 0) //seems to read 0 size row at the end -_-
         {
         // build row
         vector<double> drow;
         for (size_t i=0; i<row.size(); i++)
            drow.push_back(atof(row[i].data()));

         if (verbose > 1)
         {
            for (size_t i=0; i<row.size(); i++)
               cout << drow[i] << " ";
            cout << endl;
         }

         // insert row
         v.push_back(drow);
         }
      }
      mydatafile.close();

   } catch (string const& error) {
      // We exit if there was an error
      cerr << error << endl;
      exit(-1);
   }

   // feedback
   if (verbose > 0)
   {
      cout << "Read " << v.size() << " by " << v[0].size() << " matrix" << endl;
      cout << "First value: " << v[0][0] << " Last value: " << v[v.size()-1][v[v.size()-1].size()-1] << endl;
   }

   return (int) v.size();
}


/**
 * \fn void readCSVToVector(const string filename, vector<double> &v, const int nbCol, const char separator)
 * \param filename  : the complete path to the file.
 * \param v         : a vector in which the column content will be load.
 * \param nbCol     : the column number to load in v.
 * \param separator : the char used to parse the CSV file (default is ';').
 *
 * This function writes the content of the nbCol column of the csv file named filename in the vector v
 * assuming that file is well formated.
 *
 */
int readCSVToVector(const string filename, vector<double> &v, const int nbCol, const char separator)
{
   CSVRow row(separator);
   cout << "Start reading csv file... " << filename << endl;
   try {
      ifstream mydatafile(filename.data());
      // We check that the file has been found
      if(! mydatafile)
         throw string("Error: the file you specified cannot be opened.\nYou should check if the name is correct and/or if the file has reading permission.");
      // Check separator on the header
      string header;
      getline(mydatafile,header);
      if(header.find(separator) == string::npos) {
         stringstream error;
         error << "Error: the separator you specified \'"<< separator << "\' does not appear in the csv file." << endl;
         error << "Remember that the default separator is ';' so you may have to specify one (last argument of the function readCSVToVector).";
         throw error.str();
      }
      // Check that nbCol is ok
      mydatafile.seekg(0,ios::beg);
      mydatafile >> row;
      if(row.size() < (unsigned)nbCol || nbCol < 0)
         throw string("Error: the column number specified is higher than the row size of the csv file or lower than 0.");
      // We read the nbCol of the file until the end of file
      while (mydatafile >> row)
         v.push_back(atof(row[nbCol].data()));
      // We close the file
      mydatafile.close();
   } catch (string const& error) {
      // We exit if there was an error
      cerr << error << endl;
      exit(-1);
   }
   // We print some information on the data
   cout << "Range: " << v[0] << " | " << v[v.size()-1] << " Size: " << v.size() << endl;
   return (int) v.size();
}

/**
 * \fn void readCSVToVector(const string filename, vector<double> &v, const string colName, const char separator)
 * \param filename   : the complete path to the file.
 * \param  v         : a vector in which the column content will be load.
 * \param colName    : the column name to load in v (it is case sensitive).
 * \param separator  : the char used to parse the CSV file (default is ';').
 *
 * This function writes the content of the colName column of the csv file named filename in the vector v
 * assuming that file is well formated.
 *
 */
int readCSVToVector(const string filename, vector<double> &v, const string colName, const char separator)
{
   CSVRow row(separator);
   cout << "Start reading csv file... " << filename << endl;
   try {
      ifstream mydatafile(filename.data());
      bool found = false;
      // We check that the file has been found
      if(! mydatafile)
         throw string("Error: the file you specified cannot be opened.\nYou should check if the name is correct and/or if the file has reading permission.");
      // Check separator on the header
      string header;
      getline(mydatafile,header);
      if(header.find(separator) == string::npos) {
         stringstream error;
         error << "Error: the separator you specified \'"<< separator << "\' does not appear in the csv file." << endl;
         error << "Remember that the default separator is ';' so you may have to specify one (last argument of the function readCSVToVector).";
         throw error.str();
      }
      // We get the header
      mydatafile.seekg(0,ios::beg);
      mydatafile >> row;
      // We find nbCol associated to colName
      unsigned int nbCol = 0;
      while(!found && nbCol < row.size()){
         found = (colName == row[nbCol]);
         nbCol++;
      }
      // We incremented one more
      nbCol--;
      if(!found)
         throw string("Error: the column name specified does not exist.");
      cout << nbCol << endl;
      // We read the nbCol of the file until the end of file
      while (mydatafile >> row)
         v.push_back(atof(row[nbCol].data()));
      // We close the file
      mydatafile.close();
   } catch (string const& error) {
      // We exit if there was an error
      cerr << error << endl;
      exit(-1);
   }
   // We print some information on the data
   cout << "Range: " << v[0] << " | " << v[v.size()-1] << " Size: " << v.size() << endl;
   return (int) v.size();
}

/**
 * \fn double normalizedTimeInterpolation(const double normalized_time, const vector<double>& data)
 * \param normalized_time : the normalized time considered for interpolation.
 * \param data            : vector to interpolate.
 * \return linear interpolated value.
 *
 * This function calculates the linear interpolation of the vector data at time normalized_time.
 * It is assumed that the time discretization is uniform.
 *
 */
double normalizedTimeInterpolation(const double normalized_time, const vector<double>& data)
{
   double value = -666666;
   int data_size = (int) data.size();
   int index;

   // Out of bounds
   if (normalized_time < 0e0) {
      cerr << "Error: the normalized_time you specified for normalizedTimeInterpolation is below lower bound: normalized_time = " << normalized_time << "." << endl;
      exit(1);
   }
   else if (normalized_time > 1e0) {
      cerr << "Error: the normalized_time you specified for normalizedTimeInterpolation is out of upper bound: normalized_time = " << normalized_time << "." << endl;
      exit(1);
   }
   // Final time
   else if (normalized_time == 1.0) {
      value = data[data_size-1];
   }
   else {
      // Locate index (in [0, data_size-2])
      double h = 1e0 / (data_size-1);
      index = (int) floor(normalized_time / h);

      // Linear interpolation
      double ti = index * h;
      double alpha = (normalized_time - ti) / h;
      alpha = fmax(alpha,0e0);
      alpha = fmin(alpha,1e0);
      value = (1e0 - alpha) * data[index] + alpha * data[index+1];
   }

   return value;
}



/**
 * \fn int locate(const double value, const vector<double>& data)
 * \param value : value to locate.
 * \param data  : the vector where to locate value.
 * \return location index.
 *
 * This function returns the index in [0,data.size -2] such that data[index] <= value < data[index+1]
 * The algorithm is basic dichotomy.
 * If the value is out of bound, it returns -1 if value < data[0] and -2 if value > data[data_size-1]
 *
 */

int locateInArray(const double value, const double *data, const int data_size)
{
   int index = 0;

   // Test for out_of_bounds values
   if (value <= data[0])
      index = -1;
   else if (value >= data[data_size-1])
      index = -2;
   else {
      int start = 0;
      int end = data_size - 1;
      while (start < end)
         if (start + 1 == end)
            return start;
         else
         {
            index = (start + end) / 2;
           // if (value == data[index]) //+++ unsafe. Fix it...
           //    return index;
           // else if (value > data[index])
            if (value > data[index])
               start = index;
            else
               end = index;
         }
   }

   return index;
}

int locate(const double x_value, const vector<double> &x_data)
{
    int data_size = (int) x_data.size();
    return locateInArray(x_value,x_data.data(),data_size);
}

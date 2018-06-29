// This function allows to read the dimensions of the problem from the file 
// "problem.sol". It returns the values of the dimensions 
// n_disc : number of time steps
// dim_y : number of state variables
// dim_u :    "      control    "
// dim_z :    "      algebraic  "
// dim_p : number of parameters
// dim_path : number of path constraints
// dim_bound : number of boundary conditions
function [dim_y,dim_u,dim_z,dim_p,dim_path,dim_bound,ti,tf,n_disc]=read_sol_dimensions()


    // The parameters name as they are written in problem.def :
    names_to_seek = ["state.dimension";"control.dimension";...
    "algebraic.dimension";"parameter.dimension";...
    "constraint.dimension";"boundarycond.dimension";...
    "time.initial";"time.final";"discretization.steps"];
    associated_types = ["integer";"integer";"integer";"integer";"integer";...
    "integer";"double";"double";"integer"];

    [vec_res_str]=read_sol_param(names_to_seek,associated_types);

    vec_res = [];
    try
        vec_res = evstr(vec_res_str);
    catch
        btn = messagebox(["An error occurred when reading [problem.sol]...";...
        "Unable to read the dimensions, or time options.";...
        "These values were written as they were found in ";...
        "problem.def at the end of the optimization.";...
        "Maybe the optimization failed, or the definition";...
        "files were incorrectly written."],"Error", "error", ["Ok"]);
        //update_str("Error!","obj_text_field");
        resume;
    end

    try
        dim_y = vec_res(1);
        dim_u = vec_res(2);
        dim_z = vec_res(3);
        dim_p = vec_res(4);
        dim_path = vec_res(5);
        dim_bound = vec_res(6);
        ti = vec_res(7);
        tf = vec_res(8);
        n_disc = vec_res(9);
    catch
        btn = messagebox(["An error occurred when reading [problem.sol]...";...
        "Unable to read the dimensions, or time options.";...
        "These values were written as they were found in ";...
        "problem.def at the end of the optimization.";...
        "Maybe the optimization failed, or the definition";...
        "files were incorrectly written."],"Error", "error", ["Ok"]);
        //update_str("Error!","obj_text_field");
        resume;
    end




endfunction


//
//        +--------------------------------+
//        |                                |
//        |               READ             |
//        |             SOLUTION           |
//        |            PARAMETERS          |
//        |                                |
//        +--------------------------------+
//

// This function is used to read the parameters of the definition files used to
// generate the f_sol. All the definition files are written in commented
// lines at the beginning of the solution file. We can then retrieve these
// parameters.
function [res_param]=read_sol_param(seek_name,seek_type)

    res_param = "";

    try
        [fd,err]=mopen(solution_file, "r");
        [err,msg]=merror(fd);
    catch err
        btn = messagebox(["An error occurred when opening [problem.sol]...";...
        "Please check this file is in your problem''s directory";...
        "(this file is generated at the end of the optimization, an ";...
        "error during optimization might be the source of the problem)"],"Error", "error", ["Ok"]);
        update_str("Error!","obj_text_field");
        resume;
    end

    // We read the beginning of the file, containing a summary of the definition
    // files of the problem :
    i=1;
    all(i) = mgetl(fd,1);
    while (part(all(i),1) == "#" | all(i) == "")
        i = i+1;
        all(i) = mgetl(fd,1);
    end

    mclose(fd);

    // We look for some parameters values in these files :
    for i=1:size(seek_name,1)

        // We get the index of the line containing the name of the parameter we are 
        // interested in :
        seek_str = "# "+seek_name(i);
        ind = find(part(all,[1:length(seek_str)])==seek_str);

        if ind == [] then
            res_param(i) = "";
        else
            // We want to extract the value of the parameter. The value is written after
            // the name and the type of the parameter :
            start = length("# "+seek_name(i)+" "+seek_type(i)+" ");

            // We get the length of the line :
            len = length(all(ind));

            // Finally, we can extract the value of the parameter :
            res_param(i) = part(all(ind),(start:len));
        end

    end

endfunction


//
//        +--------------------------------+
//        |                                |
//        |               READ             |
//        |             VARIABLES          |
//        |               NAMES            |
//        |                                |
//        +--------------------------------+
//

// This function allows to read the names of the variables from the file
// <problem>.def . We will then use these names to display the solution in a 
// more friendly way.
function [name_y,name_u,name_z,name_p]=read_var_names(dim_y, dim_u, dim_z, dim_p)

    // We seek the names of the variables
    // 1) State variables :
    name_y = "";
    if dim_y<>0 then
        // First we set a new vector containing the names we are supposed to 
        // find in the first column of the file problem.sol
        names_to_seek = "state."+string([1:dim_y]');

        // The names type is "string" :
        associated_types(1:dim_y) = "string"; 

        // Then we seek each string in the solution file :
        [name_y]=read_sol_param(names_to_seek,associated_types);

        for i=1:dim_y
            if name_y(i) == "" then
                name_y(i) = names_to_seek(i);
            end
        end
    end

    // 2) Control variables :
    name_u = "";
    if dim_u<>0 then
        names_to_seek = "control."+string([1:dim_u]');
        associated_types(1:dim_u) = "string"; 
        [name_u]=read_sol_param(names_to_seek,associated_types);
        for i=1:dim_u
            if name_u(i) == "" then
                name_u(i) = names_to_seek(i);
            end
        end
    end

    // 3) Algebraic variables :
    name_z = "";
    if dim_z<>0 then
        names_to_seek = "algebraic."+string([1:dim_z]');
        associated_types(1:dim_z) = "string";
        [name_z]=read_sol_param(names_to_seek,associated_types);
        for i=1:dim_z
            if name_z(i) == "" then
                name_z(i) = names_to_seek(i);
            end
        end
    end

    // 4) Parameters :
    name_p = "";
    if dim_p<>0 then
        names_to_seek = "parameter."+string([1:dim_p]');
        associated_types(1:dim_p) = "string";
        [name_p]=read_sol_param(names_to_seek,associated_types);
        for i=1:dim_p
            if name_p(i) == "" then
                name_p(i) = names_to_seek(i);
            end
        end
    end

endfunction


//
//        +--------------------------------+
//        |                                |
//        |              READ              |
//        |           CONSTRAINTS          |
//        |              NAMES             |
//        |                                |
//        +--------------------------------+
//

// This function allows to read the names of the constraints from the file
// problem.sol . We will then use these names to display the solution in a 
// more friendly way.
function [name_bound,name_path]=read_constr_names(dim_bound,dim_path)

    // 1) Initial and final conditions :
    name_bound = "";
    if dim_bound <> 0 then
        // First we set a new vector containing the names we are supposed to 
        // find in the first column of the file problem.sol
        names_to_seek = "boundarycond."+string([1:dim_bound]');

        // The names type is "string" :
        associated_types(1:dim_bound) = "string"; 

        // Then we seek each string on the solution file :
        [name_bound]=read_sol_param(names_to_seek,associated_types);
        for i=1:dim_bound
            if name_bound(i) == "" then
                name_bound(i) = names_to_seek(i);
            end
        end
    end



    // 2) Path constraints :
    name_path = "";
    if dim_path <> 0 then
        // First we set a new vector containing the names we are supposed to 
        // find in the first column of the file problem.sol
        names_to_seek = "constraint."+string([1:dim_path]');

        // The names type is "string" :
        associated_types(1:dim_path) = "string"; 

        // Then we seek each string in the solution file :
        [name_path]=read_sol_param(names_to_seek,associated_types);
        for i=1:dim_path
            if name_path(i) == "" then
                name_path(i) = names_to_seek(i);
            end
        end
    end

endfunction


//
//        +--------------------------------+
//        |                                |
//        |              READ              |
//        |           BOUNDARIES           |
//        |                                |
//        +--------------------------------+
//
// Function to read a boundary file (<problem>.bounds)
function [low_bound,up_bound,type_bound]=read_bounds(dim_bound,dim_path)

    // Read the bounds definition file to check whether the results are correct or not
    //filename = gettext(name_pb+".bounds");
    //    filename = "problem.bounds";
    //    f_bounds = fullfile(solution_path,filename);

    f_bounds = solution_file;


    // Opening file
    [fd,err]=mopen(f_bounds, "r")

    // Detecting an error
    [err,msg] = merror(fd);


    // The bounds definition file is organized as follow :
    // - number of boundary conditions and number of path constraints 
    // - boundary bounds (dimension : dim_bound_cond_def)
    // - path bounds (dimension : dim_path_cond_def)
    // for the path and the boundary bounds, each line contains the lower bound, the 
    // upper bound, and the type of expression :
    //    0 : no bound
    //    1 : only lower bound
    //    2 : only upper bound
    //    3 : both bounds
    //    4 : equality


    // We ignore the comment lines :
    current = mtell(fd); // current position in the file
    first=mfscanf(1,fd,"%s");
    while part(first,1) == "#" 
        // the line is a comment, we ignore it
        txt=mgetl(fd,1);
        current = mtell(fd);
        // we read the first character of the next line :
        first=mfscanf(1,fd,"%s"); 
    end
    // Read the dimensions (first 6 values of the file)
    mseek(current,fd,"set");
    [n,bounds_dim]=mfscanf(6,fd,"%d");

    // We check the dimensions:
    if (bounds_dim(1) <> (dim_bound) | bounds_dim(6) <> dim_path) then
        disp("GUI : read_bounds() ---> Dimensions do not match!");
    end


    // Then we read the values of the bounds
    dim_total = dim_bound + dim_path;
    //[n,low_bound,up_bound,type_bound]=mfscanf(dim_total,fd, "%lg %lg %d");

    i=0;
    while  (i < dim_total)

        // We need the current position in the file :
        current = mtell(fd);
        // We read the first character on the line :
        first=mfscanf(1,fd,"%s");

        if part(first,1)~="#" then
            // The line is not a comment, we need to read the values.

            // First we get back at the beginning of the line. We have read one
            // string, we need to rewind to the previous position
            mseek(current,fd,"set");

            // Then we read three values (lower bound, uppper bound and type)
            [n,low_bound($+1),up_bound($+1),type_bound($+1)]=mfscanf(1,fd, "%lg %lg %d");

            i=i+1;
            //disp(i);
        else
            // If the first character is "#", we ignore the comment line.
            // We read the whole line, and put it into a trash variable
            txt=mgetl(fd,1);
            //disp(txt);
        end

    end


    err = mclose(fd);
    //    disp(low_bound);
    //    disp(up_bound);
    //    disp(type_bound);

endfunction



//
//        +--------------------------------+
//        |                                |
//        |             CHECK              |
//        |           BOUNDARIES           |
//        |                                |
//        +--------------------------------+
//
// Function to read a boundary file (<problem>.bounds)
function check_bounds(value, b_left, b_right, b_type, field_tag)

    eps = 0.001;

    select b_type
    case 0 then // no bounds
        valid = %t;
    case 1 then // left bound only
        if value >= b_left-eps then
            valid = %t;
        else
            valid = %f;
        end
    case 2 then // right bound only
        if value <= b_right+eps then
            valid = %t;
        else
            valid = %f;
        end
    case 3 then // both bounds
        if (value >= b_left-eps & value <= b_right+eps) then
            valid = %t;
        else
            valid = %f;
        end
    case 4 then // equality
        if (abs(value-b_left) <= eps & abs(value-b_right) <= eps) then
            valid = %t;
        else
            valid = %f;
        end
    else
        disp("Unknown format for the bounds...");
        valid = %f;
    end
    //    disp(b_type, b_right,value, b_left);
    //    disp(valid);

    text_field_handle = findobj("Tag",string(field_tag));  // search the text field to modify
    if valid == %t then
        text_field_handle.string = "OK"; // modify the field's string
        text_field_handle.ForegroundColor = [0 1 0]; // color of the text (green)
    else
        text_field_handle.string = "X";
        text_field_handle.ForegroundColor = [1 0 0];
    end
endfunction


//
//        +--------------------------------+
//        |                                |
//        |               LOAD             |
//        |             SOLUTION           |
//        |                                |
//        +--------------------------------+
//
// Function to load a solution file 
function [t_node,t_stage,y,u,z,p,path_cond,bound_cond,dyna_cond]=load_solution_file()

    // this function can set a new value for the directory where the solution
    // file is located :
    global solution_file; 

    t_node = [];
    t_stage = [];
    obj_func = [];
    y = [];
    u = [];
    z = [];
    p = [];
    path_cond = [];
    bound_cond = [];
    dyna_cond = [];

    // Depending on which button called the function, we read either the current
    // default problem.sol file, or a solution file selected by user :
    //select gcbo.tag,
    //case "current_sol_but" then
        f_solution = fullfile(problem_path,"problem.sol");
    //case "another_sol_but" then
    //    f_solution = uigetfile(["*.sol*"],".","Select a solution file to load :");
    //    if f_solution == "" then
    //        resume;
    //    end
    //else
    //    btn = messagebox(["An error occurred when reading [problem.sol]...";...
    //    "Unable to read the dimensions, or time options.";...
    //    "These values were written as they were found in ";...
    //    "problem.def at the end of the optimization.";...
    //    "Maybe the optimization failed, or the definition";...
    //    "files were incorrectly written."],"Error", "error", ["Ok"]);
    //    resume;
    //end

    solution_file = f_solution;

    // We read the file :
    [t_node,t_stage,y,u,z,p,path_cond,bound_cond,dyna_cond]=read_solution(f_solution);

endfunction




//
//        +--------------------------------+
//        |                                |
//        |               READ             |
//        |             SOLUTION           |
//        |                                |
//        +--------------------------------+
//
// Function to read a solution file (<problem>.sol)
function [t_node,t_stage,y,u,z,p,path_cond,bound_cond,dyna_cond_y]=read_solution(f_solution)

    //switch_visu_buttons("off");

    //update_str("Reading .sol file, please wait...","obj_text_field");

    // problem.sol file can be very large in memory, so we check that Scilab
    // stack size is large enough to read it, and store it in variables :
    details = fileinfo(f_solution);// retrieve file details
    len = details(1); // length of the file
    
    //    disp(len,"file = ");
    //
    //    st = stacksize();
    //    disp(st,"avant = ");
    
    st = stacksize();

    if (st(1)-st(2)<2*len) then
//        try
            //stacksize(st(2)+2*len);
            stacksize("max");
//        catch
//            try
//                stacksize("max");
//            catch
//                btn = messagebox(["An error occurred when trying to set stacksize";...
//                "value to its maximum (Scilab error). Please try again"],"Error", "error", ["Ok"]); 
//                resume;
//            end
//            btn = messagebox(["An error occurred when trying to increase stacksize";...
//            "value (Scilab error). Maybe this value was more than the";...
//            "allowed maximum. In such case, the file you are trying ";...
//            "to open might be to big to be read with Scilab...";...
//            "However, the stack has been set to its maximum size, which";...
//            "could be sufficiently large to load the file. You can wait";...
//            "to see if the process terminates..."],"Warning", "warning", ["Ok"]); 
//        end
//
end

    // First we need to know the dimensions of the problem, they are written at
    // the beginning of the file, in the comments :
    [dim_y,dim_u,dim_z,dim_p,dim_path,dim_bound,ti,tf,n_disc]=read_sol_dimensions();
    


    // The solution is contained in the following file :
    //filename = gettext(name_pb+".init.test");
    //    filename = "problem.sol";
    //    f_solution = fullfile(problem_path,filename);

    // Opening file
    try
        [fd,err]=mopen(f_solution, "r");
        [err,msg]=merror(fd);
    catch err
        btn = messagebox(["An error occurred when opening [problem.sol]...";...
        "Please check this file is in your problem''s directory";...
        "(this file is generated at the end of the optimization, an ";...
        "error during optimization might be the source of the problem)"],"Error", "error", ["Ok"]);
        //update_str("Error!","obj_text_field");
        resume;
    end



    //    st = stacksize();
    //    disp(st,"apres = ");
    

    

    // the output C++ file contains :
    // 1) The boundary conditions
    // 2) A loop over the time discretization giving :
    //     - the path constraints
    //     - the dynamic constraints

    skip_comments(fd);

    try
        // Value of the objective function (beginning of the file) :
        [n,obj_func]=mfscanf(1,fd, "%lg");

        // L2 norm of the constraints vector (constraint violation) :
        skip_comments(fd);
        [n,L2_norm]=mfscanf(1,fd, "%lg");

        // Inf norm of the constraints vector (constraint violation) :
        skip_comments(fd);
        [n,Inf_norm]=mfscanf(1,fd, "%lg");

        // Number of stages of the discretization method :
        skip_comments(fd);
        [n,s]=mfscanf(1,fd, "%d");


    catch
        btn = messagebox(["An error occurred when reading [problem.sol]...";...
        "Unable to read the value of the objective function ";...
        "(first value of the file). [problem.sol] might be empty ";...
        "(this file is generated at the end of the optimization, an ";...
        "error during optimization might be the source of the problem)"],"Error", "error", ["Ok"]);
        //update_str("Error!","obj_text_field");
        err = mclose(fd);
        resume;
    end

    //disp(obj_func);
    //disp(s);

    // In order to display the waitbar, we need to know what the total amount
    // of time will be. We have to read all the variables, and constraints. 
    // Each variable has n_disc values, and some constraints have n_disc*s 
    // values. We can ignore single values (objective, parameters) to guess the
    // estimate amount of time :
    time_total = dim_y + dim_u + dim_z + 4*(dim_y + (dim_path+dim_y)*s) + (s+1);
    wait_prop = 0/time_total
    id_wait = waitbar(wait_prop,"Loading solution...");

    // Then the file contains the vector of discretized variables (y, u, z, p)
    // We need to extract the values y, u, z and p from problem.sol :
    y = []; u = []; z = []; p = []; 
    try
        // Extract y :
        for i=1:dim_y
            skip_comments(fd);
            for l=1:n_disc+1
                y(l,i) = mfscanf(1,fd, "%lg");
            end
            wait_prop = wait_prop + 1/time_total;
            waitbar(wait_prop,id_wait);

        end
        //disp(y,"y = ");

        // Extract u : //+++ a revoir (dimensions nulles)
        for i=1:dim_u
            skip_comments(fd);
            for l=1:n_disc
                u(l,i) = mfscanf(1,fd, "%lg");
            end
            wait_prop = wait_prop + 1/time_total;
            waitbar(wait_prop,id_wait);
        end
        //disp(u,"u = ");

        // Extract z : 
        for i=1:dim_z
            skip_comments(fd);
            for l=1:n_disc
                z(l,i) = mfscanf(1,fd, "%lg");
            end
            wait_prop = wait_prop + 1/time_total;
            waitbar(wait_prop,id_wait);
        end
        //disp(z, "z = ");

        // Extract p :
        for i=1:dim_p
            skip_comments(fd);
            p(i) = mfscanf(1,fd, "%lg");
        end
        //disp(p, "p = ");

    catch
        btn = messagebox(["An error occurred when reading [problem.sol]...";...
        "Unable to read the main solution vector for the discretized variables";...
        "(problem.sol might be too big to be read with Scilab... An error in";...
        "the dimensions of the variables, or an error during optimization might";...
        "also be the source of the problem)"],"Error", "error", ["Ok"]);
        //update_str("Error!","obj_text_field");
        winclose(id_wait);
        err = mclose(fd);
        resume;
    end

    path_cond = []; bound_cond = []; 
    try 
        // Number of boundary conditions
        for i=1:dim_bound
            skip_comments(fd);
            bound_cond(i,:)=mfscanf(1,fd, "%lg %lg %lg %lg");
        end
        //disp(bound_cond,"bound_cond = ");

        // Path constraints : 
        // we have path_cond(i,j,k)
        // i : 1) lower bound, 2) value of the constraint 3) upper bound 4) type
        // j : time step of the constraint
        // k : number of the constraint
        for j=1:dim_path
            skip_comments(fd);
            for i = 1:n_disc*s
                path_cond(:,i,j)=mfscanf(1,fd, "%lg %lg %lg %lg");
            end
            wait_prop = wait_prop + 4*s/time_total;
            waitbar(wait_prop,id_wait);
        end
        //disp(path_cond,"path_cond = ");

        // Dynamic constraints
        for j=1:dim_y
            skip_comments(fd);
            for i=1:n_disc
                dyna_cond_y(:,i,j)=mfscanf(1,fd, "%lg %lg %lg %lg");
                //disp(dyna_cond_y(:,i,j));
            end
            wait_prop = wait_prop + 4/time_total;
            waitbar(wait_prop,id_wait);
        end
        //disp(dyna_cond_y, "dyna_cond = ")


        for j=1:dim_y
            skip_comments(fd);
            for i=1:n_disc*s
                dyna_cond_k(:,i,j)=mfscanf(1,fd, "%lg %lg %lg %lg");
                //disp(i,j,"i j = ");
            end
            wait_prop = wait_prop + 4*s/time_total;
            waitbar(wait_prop,id_wait);

        end
        //disp(dyna_cond_k, "dyna_cond_k = ")

    catch
        btn = messagebox(["An error occurred when reading [problem.sol]...";...
        "Unable to read the values of the constraints (i&f conditions,";...
        "path constraints, or dynamic equations)";...
        "(problem.sol might be too big to be read with Scilab... An error in";...
        "the dimensions of the constraints, or an error during optimization";...
        " might also be the source of the problem)"],"Error", "error", ["Ok"]);
        //update_str("Error!","obj_text_field");
        winclose(id_wait);
        err = mclose(fd);
        resume;
    end


    // Finally we read the vector of discretized time, at the end of the file
    try
        skip_comments(fd);
        for j=1:n_disc
            t_node(j)=mfscanf(1, fd, "%lg");
            for i=1:s
                t_stage($+1)=mfscanf(1, fd, "%lg");
            end
        end
        wait_prop = wait_prop + (s+1)/time_total;
        waitbar(wait_prop,id_wait);
        t_node($+1)=mfscanf(1, fd, "%lg");
    catch
        btn = messagebox(["An error occurred when reading [problem.sol]...";...
        "Unable to read the values of the discretized times";...
        "(problem.sol might be too big to be read with Scilab... An error in";...
        "the dimensions of the constraints, or an error during optimization";...
        " might also be the source of the problem)"],"Error", "error", ["Ok"]);
        //update_str("Error!","obj_text_field");
        winclose(id_wait);
        err = mclose(fd);
        resume;
    end

    //     hy = scf(); // Create a new window for the graph
    //     h_y = figure(hy,"figure_name", gettext("Solution plot"));
    //    plot2d(t_stage, dyna_cond_y(:,:,1))
    //disp(t_node, "t_node = ");
    //disp(t_stage, "t_stage = ")

    // Closing file
    err = mclose(fd);

    // We display the result of the objective function in the main window :
    obj_txt = "Objective value : "+get_c_string("%.5e",obj_func)+...
    " --- Max. constraint violation : "+get_c_string("%.5e",Inf_norm);
    //update_str(obj_txt,"obj_text_field");

    //switch_visu_buttons("on");
    winclose(id_wait);

    //    st = stacksize();
    //    disp(st,"fin = ");

endfunction

[t_node,t_stage,y,u,z,p,path_cond,bound_cond,dyna_cond]=load_solution_file();




// custom graph for heat equation
figure;
clf();
title("STATE (EVOLUTION IN TIME)","fontsize",4);
xlabel("SPACE","fontsize",4);
ns = size(y,2) - 1;
timesteps = size(y,1);
tf = 20;
h = 1/(ns-1);
space=[0:h:1];
plot(space(1:ns),y(1,1:ns)); //t=0
plot(space(1:ns),y(2,1:ns)); //t=0.25
plot(space(1:ns),y(timesteps/20+1,1:ns)); //t=1
plot(space(1:ns),y(timesteps/8+1,1:ns)); //t=2.5
plot(space(1:ns),y(timesteps/4+1,1:ns)); //t=5
plot(space(1:ns),y(timesteps,1:ns)); //t=20

ax = gca();
ax.data_bounds=[0 1 -1 1.1];
ax.thickness = 2;
ax.font_size = 2;

for i=1:6
 graph=ax.children(i);
 graph.children(1).thickness = 2; 
 graph.children(1).foreground = i;
end

leg = legend("t=0","t=0.1","t=1","t=2.5","t=5","t=20",4);
leg.font_size = 2;


figure;
clf();
title("CONTROL","fontsize",4);
xlabel("TIME","fontsize",4);
plot(t_node(1:timesteps-1),u(:,1))
ax = gca();
ax.data_bounds=[0 tf -1.1 0.5];
ax.thickness = 2;
ax.font_size = 2;
graph=ax.children(1);
graph.children(1).thickness = 2; 


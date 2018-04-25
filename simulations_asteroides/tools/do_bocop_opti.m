function do_bocop_opti(destination, outputOptimization, q0_SUN_AU, t0_day, TmaxN, tf_guess, m0, dist)

    UC          = get_Univers_Constants(); % Univers constants

    dv0_r_KM_S  = outputOptimization.dV0_r/UC.jour*UC.AU; % km / s
    fprintf('dv0_r_KM_S = \n'); disp(dv0_r_KM_S);
    dv1_r_KM_S  = outputOptimization.dV1_r/UC.jour*UC.AU; % km / s
    fprintf('dv1_r_KM_S = \n'); disp(dv1_r_KM_S);

    % Define Bocop and HamPath parameters
    [q0_CR3BP,~,~,~,thetaS0] = Helio2CR3BP(q0_SUN_AU, t0_day); % q0 in LD/d
    q0          = q0_CR3BP(1:6); q0 = q0(:);
    qf          = [UC.xL2 0.0 0.0 0.0 0.0 0.0]';

    Tmax        = TmaxN*1e-3*(UC.time_syst)^2/UC.LD; fprintf('Tmax = %f \n', Tmax);
    muCR3BP     = UC.mu0MoonLD/(UC.mu0EarthLD+UC.mu0MoonLD);
    muSun       = UC.mu0SunLD/(UC.mu0EarthLD+UC.mu0MoonLD);
    rhoSun      = UC.AU/UC.LD;
    omegaS      = (-(UC.speedMoon+UC.NoeudMoonDot)+2*pi/UC.Period_EMB)/UC.jour*UC.time_syst;
    tf_guess    = tf_guess*UC.jour/UC.time_syst; % time in UT

    g0          = 9.80665*1e-3*(UC.time_syst)^2/UC.LD;
    Isp         = 375/UC.time_syst; % 375 s
    beta        = 1.0/(Isp*g0); fprintf('beta = %f \n', beta);

    fprintf('beta*Tmax = %f \n', beta*Tmax);

    % ---------------
    min_dist_2_earth    = 0.0;      %
    init_choice         = 'none1';  % 'none1' -- 'warm1' or 'warm2' if numAsteroid = numOpti = 1

    % Unique name to save intermediate results
    case_name   = ['./min_tf_Tmax_' num22str(TmaxN,3) '_m0_' num22str(m0,6) '_ast_' int2str(outputOptimization.numAsteroid) '_dist_' num22str(dist,4) ...
                    '_dist_min_2_earth_' num22str(min_dist_2_earth,2)];

    dir_results = ['./results/compare_return_non_constant_mass/' destination '/in_progress_results/'];

    if(~exist(dir_results,'dir')); error('Wrong dir_results name!'); end

    file_results= [dir_results case_name];

    if(exist([file_results '.mat'],'file')==2)
        load(file_results);
    else
        results = [];
        results.exec_min_tf_bocop                   = -1;
        results.exec_min_tf_hampath                 = -1;
        results.exec_regul_log                      = -1;
        results.exec_min_conso_free_tf              = -1;
        results.exec_min_conso_non_constant_mass    = -1;
        results.exec_min_conso_fixed_tf             = -1;
        results.exec_homotopy_tf                    = -1;
        results.exec_homotopy_m0                    = -1;
        save(file_results, 'results');
    end

    results.exec_min_tf_bocop=-1;
    %results.exec_min_tf_hampath=-1;
    %results.exec_regul_log = -1;
    %results.exec_min_conso_free_tf = -1;
    %results.exec_min_conso_non_constant_mass    = -1;
    %results.exec_min_conso_fixed_tf = -1;
    %results.exec_homotopy_tf = -1;
    %results.exec_homotopy_m0 = -1;

    % ----------------------------------------------------------------------------------------------------
    % Bocop solution : min tf
    %
    disp('Bocop solution : min tf');
    %
    min_tf_bocop        = [];

    % parameters
    m0_init     = m0;
    par_bocop   = [q0; qf; Tmax; muCR3BP; muSun; rhoSun; thetaS0; omegaS; m0_init; min_dist_2_earth];

    n           = 6;
    dimStates   = n;
    inc         = 1;
    iq0         = inc:inc+dimStates-1;      inc = inc + dimStates;
    iqf         = inc:inc+dimStates-1;      inc = inc + dimStates;
    iTmax       = inc;                      inc = inc + 1;
    imuCR3BP    = inc;                      inc = inc + 1;
    imuSun      = inc;                      inc = inc + 1;
    irhoSun     = inc;                      inc = inc + 1;
    ithetaS0    = inc;                      inc = inc + 1;
    iomegaS     = inc;                      inc = inc + 1;
    im0         = inc;                      inc = inc + 1;
    imin_dist_2_earth = inc;                inc = inc + 1;

    keySet      = {'q0','qf','Tmax','muCR3BP','muSun','rhoSun','thetaS0','omegaS','m0','min_dist_2_earth'};
    valueSet    = {iq0, iqf, iTmax, imuCR3BP, imuSun, irhoSun, ithetaS0, iomegaS, im0, imin_dist_2_earth};
    map_indices_par_bocop = containers.Map(keySet, valueSet);

    % Initialization
    defPbBocop  = './bocop/';                                                 % Directory where main bocop pb directory is: ./bocop/def_pb_temps_min/

    if(strcmp(init_choice, 'none1')==1)

        options             = [];
        options.disc_steps  = '200';
        options.disc_method = 'gauss';

        solFileSave = './min_tf_current.sol';

        init.type   = 'from_init_file';
        init.file   = 'none';
        init.X0     = [
            {'state.0','constant',(q0(1)+qf(1))/2};         % q1
            {'state.1','constant',(q0(2)+qf(2))/2};         % q2
            {'state.2','constant',(q0(3)+qf(3))/2};         % q3
            {'state.3','constant',(q0(4)+qf(4))/2};         % v1
            {'state.4','constant',(q0(5)+qf(5))/2};         % v2
            {'state.5','constant',(q0(6)+qf(6))/2};         % v3
            {'control.0','constant',sign(qf(1)-q0(1))*0.2};                  % u1
            {'control.1','constant',sign(qf(2)-q0(2))*0.2};                  % u2
            {'control.3','constant',0.0};                   % u3
            {'optimvars','constant',1.0*tf_guess}];         % tf

    else

        error('No such init_choix!');

    end

    % Computation
    if(results.exec_min_tf_bocop==-1)

        [toutB,stageB,zB,uB,optimvarsB,outputB] = exec_bocop_min_tf(defPbBocop, init, par_bocop, options, solFileSave);
        fprintf('outputB = '); disp(outputB);

        if(outputB.status ~= 0)
            error('Bocop did not converge for the minimal time problem!');
        end

        % useful
        min_tf_bocop.indices        = map_indices_par_bocop;

        % inputs
        min_tf_bocop.init           = init;
        min_tf_bocop.par            = par_bocop;
        min_tf_bocop.options        = options;

        % outputs
        min_tf_bocop.toutB          = toutB;
        min_tf_bocop.stageB         = stageB;
        min_tf_bocop.zB             = zB;
        min_tf_bocop.uB             = uB;
        min_tf_bocop.optimvarsB     = optimvarsB;
        min_tf_bocop.outputB        = outputB;

        % Save in progress results
        results.exec_min_tf_bocop   = 1;
        results.min_tf_bocop        = min_tf_bocop;
        save(file_results, 'results');

    end

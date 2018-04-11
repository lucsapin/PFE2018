% Script pour lancer les optimisations retour, aller puis aller-retour

destination = 'L2';

repOutputReturn = ['results/return_impulse_' destination '/'];
if(~exist(repOutputReturn,'dir')); error('Wrong result directory name!'); end

repOutputOutbound = ['results/outbound_impulse_' destination '/'];
if(~exist(repOutputOutbound,'dir')); error('Wrong result directory name!'); end

repOutput = ['results/total_impulse_' destination '/'];
if(~exist(repOutputOutbound,'dir')); error('Wrong result directory name!'); end

file2save = [repOutput 'current_optimization.mat'];
if(~exist(file2save,'file'))
    init_numAsteroid            = 1;
    init_tour_init              = 1;
    init_numOptiReturn          = 1;
    init_numOptiOutbound        = 1;
    init_numAsteroid_save       = init_numAsteroid;
    init_tour_init_save         = init_tour_init;
    init_numOptiReturn_save     = init_numOptiReturn;
    init_numOptiOutbound_save   = init_numOptiOutbound;
else
    load(file2save);
    init_numAsteroid        = init_numAsteroid_save;
    init_tour_init          = init_tour_init_save;
    init_numOptiReturn      = init_numOptiReturn_save;
    init_numOptiOutbound    = init_numOptiOutbound_save;
end

fprintf('init_numAsteroid = %d \n', init_numAsteroid);
fprintf('init_tour_init = %d \n', init_tour_init);
fprintf('init_numOptiReturn = %d \n', init_numOptiReturn);
fprintf('init_numOptiOutbound = %d \n', init_numOptiOutbound);

for numAsteroid=init_numAsteroid:4258

    fprintf('numAsteroid = %d \n', numAsteroid);

    for tour_init=init_tour_init:19
        fprintf('tour_init = %d \n', numAsteroid);
        return_impulse_optimization(numAsteroid, tour_init, destination);
        init_tour_init_save = init_tour_init_save + 1;
        save(file2save, 'init_tour_init_save', 'init_numAsteroid_save', 'init_numOptiReturn_save', 'init_numOptiOutbound_save');
    end

    file2load = [repOutputReturn 'asteroid_no_' int2str(numAsteroid)];
    if(exist([file2load '.mat'],'file')==2)
        load(file2load);
        nbOpti = length(allResults);
        for numOptiReturn=init_numOptiReturn:min(15,nbOpti)

            fprintf('numOptiReturn = %d \n', numOptiReturn);
            outbound_impulse_optimization(numAsteroid, numOptiReturn, destination);
            init_numOptiReturn_save = init_numOptiReturn_save + 1;
            save(file2save, 'init_tour_init_save', 'init_numAsteroid_save', 'init_numOptiReturn_save', 'init_numOptiOutbound_save');

        end
        clear allResults;
    end

    file2load = [repOutputOutbound 'asteroid_no_' int2str(numAsteroid)];
    if(exist([file2load '.mat'],'file')==2)
        load(file2load);
        nbOpti = length(allResults);
        for numOptiOutbound=init_numOptiOutbound:min(10,nbOpti)

            fprintf('numOptiOutbound = %d \n', numOptiOutbound);
            total_impulse_optimization(numAsteroid, numOptiOutbound, destination);
            init_numOptiOutbound_save = init_numOptiOutbound_save + 1;
            save(file2save, 'init_tour_init_save', 'init_numAsteroid_save', 'init_numOptiReturn_save', 'init_numOptiOutbound_save');

        end
        clear allResults;
    end

    init_numOptiOutbound_save   = 1;
    init_numOptiReturn_save     = 1;
    init_tour_init_save         = 1;
    init_tour_init              = init_tour_init_save;
    init_numOptiReturn          = init_numOptiReturn_save;
    init_numOptiOutbound        = init_numOptiOutbound_save;
    init_numAsteroid_save       = init_numAsteroid_save + 1;
    save(file2save, 'init_tour_init_save', 'init_numAsteroid_save', 'init_numOptiReturn_save', 'init_numOptiOutbound_save');

end



function Results = model_select(Xrec_all, Xte_all, Tte_all, Params)


if strcmp(Params.monkey,'chewie')||strcmp(Params.monkey,'jango')||strcmp(Params.monkey,'mihi2D')
    
    minKL= Params.minKL;
    numSamples = Params.numSamples;
    numDelays = Params.numDelays;
    SmoothingFac = Params.SmoothingFac;
    M1 = Params.M1;
    Xtr = Params.Xtr;
    Ttr = Params.Ttr;

    %% Model 1. minKL (C/J)
    % Find model with smallest KL (min-KL)
    tmp = minKL;
    [~,idd] = min(tmp(:));
    [i_minKL,j_minKL,k_minKL,m_minKL] = ind2sub(size(tmp),idd);
    
    Results.coords_minKL = [i_minKL,j_minKL,k_minKL,m_minKL];
    Results.numD_minKL = numDelays(i_minKL);
    Results.numS_minKL = numSamples(j_minKL);
    Results.sfac_minKL = SmoothingFac(k_minKL);
    Results.drmethod_minKL = M1{m_minKL};
    Results.R2vals_minKL = evalR2(Xrec_all{i_minKL,j_minKL,k_minKL,m_minKL}(:,1:2),Xte_all{i_minKL,j_minKL,k_minKL,1}(:,1:2)); % final R2 for best solution (min KL)
    Results.Pcorr_minKL = evalCorrectTargets(Xrec_all{i_minKL,j_minKL,k_minKL,m_minKL}(:,1:2),normal(Xte_all{i_minKL,j_minKL,k_minKL,1}(:,1:2)),Tte_all{i_minKL,j_minKL,k_minKL,1});
    Results.Xte_minKL = Xte_all{i_minKL,j_minKL,k_minKL,1};
    Results.Tte_minKL = Tte_all{i_minKL,j_minKL,k_minKL,1};
    display(['Model = minKL, R2 Value = ', num2str(Results.R2vals_minKL,2)])

    %% Model 2. Smoothed KL model select (C/J)
    
    Vals = smooth([minKL(1)*ones(10,1); minKL(:); minKL(end)*ones(10,1)]);
    Vals = Vals(11:end-10);
    [~,id] = min(Vals);
    tmp1=max(1,id-2):min(id+2,length(Vals)); 
    [~,idd] = min(minKL(tmp1)); 
    minID2 = tmp1(idd);

    [i_smooth,j_smooth,k_smooth,m_smooth] = ind2sub(size(minKL),minID2);

    Results.coords_smooth = [i_smooth,j_smooth,k_smooth,m_smooth];
    Results.numD_smooth = numDelays(i_smooth);
    Results.numS_smooth = numSamples(j_smooth);   
    Results.sfac_smooth = SmoothingFac(k_smooth);
    Results.drmethod_smooth = M1{m_smooth};
    Results.R2vals_smooth = evalR2(Xrec_all{i_smooth,j_smooth,k_smooth,m_smooth}(:,1:2),Xte_all{i_smooth,j_smooth,k_smooth,1}(:,1:2)); % final R2 for best solution (min KL)
    Results.Pcorr_smooth = evalCorrectTargets(Xrec_all{i_smooth,j_smooth,k_smooth,m_smooth}(:,1:2),normal(Xte_all{i_smooth,j_smooth,k_smooth,1}(:,1:2)),Tte_all{i_smooth,j_smooth,k_smooth,1});
    Results.Xte_smooth = Xte_all{i_smooth,j_smooth,k_smooth,1};
    Results.Tte_smooth = Tte_all{i_smooth,j_smooth,k_smooth,1};
    
    display(['Model = SmoothKL, R2 Value = ', num2str(Results.R2vals_smooth,2)])

    %% Model 3. maxR2 (supervised data) (C/J)
    
    R2vals = zeros(length(numDelays),length(numSamples),length(SmoothingFac),length(M1));
    for k1=1:length(numDelays)
        for k2=1:length(numSamples)
            for i=1:length(SmoothingFac)
                for j=1:length(M1)

                    L = size(Xrec_all{k1,k2,i,j},1);
                    M = round(L/2);
                    tmp = find(diff(Tte_all{k1,k2,i,1}(M:end))); 

                    if ~isempty(tmp)  
                        whichid = M + tmp(1)-1;
                    else
                        error('Target vector is empty!')
                    end

                    trainid = 1:whichid;

                    R2vals(k1,k2,i,j)=evalR2(Xrec_all{k1,k2,i,j}(trainid,1:2),Xte_all{k1,k2,i,1}(trainid,1:2));
                end
            end
        end
    end

    [~,idd] = max(R2vals(:)); 
    [i_maxR2,j_maxR2,k_maxR2,m_maxR2] = ind2sub(size(R2vals),idd);

    Results.coords_maxR2 = [i_maxR2,j_maxR2,k_maxR2,m_maxR2];
    Results.numD_maxR2 = numDelays(i_maxR2);
    Results.numS_maxR2 = numSamples(j_maxR2);
    Results.sfac_maxR2 = SmoothingFac(k_maxR2);
    Results.drmethod_maxR2 = M1{m_maxR2};
    Results.R2vals_maxR2 = evalR2(Xrec_all{i_maxR2,j_maxR2,k_maxR2,m_maxR2}(:,1:2),Xte_all{i_maxR2,j_maxR2,k_maxR2,1}(:,1:2));
    Results.Xte_maxR2 = Xte_all{i_maxR2,j_maxR2,k_maxR2,m_maxR2};
    Results.Tte_maxR2 = Tte_all{i_maxR2,j_maxR2,k_maxR2,m_maxR2};

    display(['Model = maxR2, R2 Value = ', num2str(Results.R2vals_maxR2,2)])


    %% Model 4. Target Error (C/J)
    TargErr = zeros(length(numDelays),length(numSamples),length(SmoothingFac),length(M1));
    for k1=1:length(numDelays)
        for k2=1:length(numSamples)
            for i=1:length(SmoothingFac)
                for j=1:length(M1) 
                    targvec = predictTargets(Xrec_all{k1,k2,i,j},Xtr(:,1:2),Ttr);

                    L = size(Xrec_all{k1,k2,i,j},1);
                    M = round(L/2);
                    tmp = find(diff(Tte_all{k1,k2,i,1}(M:end))); 
                    whichid = M + tmp(1)-1;

                    trainid = 1:whichid;

                    TargErr(k1,k2,i,j) = sum( targvec(trainid) ~= Tte_all{k1,k2,i,1}(trainid) );
                end
            end
        end
    end

    [~,idd] = min(TargErr(:)); 
    [i_maxTarg,j_maxTarg,k_maxTarg,m_maxTarg] = ind2sub(size(TargErr),idd);

    Results.coords_maxTarg = [i_maxTarg,j_maxTarg,k_maxTarg,m_maxTarg];
    Results.numD_maxTarg = numDelays(i_maxTarg);
    Results.numS_maxTarg = numSamples(j_maxTarg);
    Results.sfac_maxTarg = SmoothingFac(k_maxTarg);
    Results.drmethod_maxTarg = M1{m_maxTarg};
    Results.R2vals_maxTarg = evalR2(Xrec_all{i_maxTarg,j_maxTarg,k_maxTarg,m_maxTarg}(:,1:2),Xte_all{i_maxTarg,j_maxTarg,k_maxTarg,1}(:,1:2));
    Results.Xte_maxTarg = Xte_all{i_maxTarg,j_maxTarg,k_maxTarg,1};
    Results.Tte_maxTarg = Tte_all{i_maxTarg,j_maxTarg,k_maxTarg,1};

    display(['Model = maxTarg, R2 Value = ', num2str(Results.R2vals_maxTarg,2)])
    
%%%%%%%%%%%%% optimize bin size as well     
elseif strcmp(Params.monkey,'mihi')
    
    minKL= Params.minKL;
    SmoothingFac = Params.SmoothingFac;
    binsz = Params.binsz;
    M1 = Params.M1;
    Xtr = Params.Xtr;
    Ttr = Params.Ttr;

    %% Model 1. smallest KL (min-KL) (M)
    tmp = minKL;
    [~,idd] = min(tmp(:));
    [i_minKL,j_minKL,k_minKL] = ind2sub(size(tmp),idd);

    Results.coords_minKL = [i_minKL,j_minKL,k_minKL];
    Results.binsz_minKL = binsz(i_minKL);
    Results.sfac_minKL = SmoothingFac(j_minKL);
    Results.drmethod_minKL = M1{k_minKL};
    Results.R2vals_minKL = evalR2(Xrec_all{i_minKL,j_minKL,k_minKL}(:,1:2),Xte_all{i_minKL,j_minKL,1}(:,1:2)); % final R2 for best solution (min KL)
    Results.Pcorr_minKL = evalCorrectTargets(Xrec_all{i_minKL,j_minKL,k_minKL}(:,1:2),normal(Xte_all{i_minKL,j_minKL,1}(:,1:2)),Tte_all{i_minKL,j_minKL,1});
    Results.Xte_minKL = Xte_all{i_minKL,j_minKL,1};
    Results.Tte_minKL = Tte_all{i_minKL,j_minKL,1};

    display(['Model = minKL, R2 Value = ', num2str(Results.R2vals_minKL,2)])

    %% Model 2. smoothed KL (M)
    
    Vals = smooth([minKL(1)*ones(10,1); minKL(:); minKL(end)*ones(10,1)]);
    Vals = Vals(11:end-10);
    [~,id] = min(Vals);
    tmp1=max(1,id-2):min(id+2,length(Vals)); 
    [~,idd] = min(minKL(tmp1)); 
    minID2 = tmp1(idd);

    [i_smooth,j_smooth,k_smooth] = ind2sub(size(minKL),minID2);

    Results.coords_smooth = [i_smooth,j_smooth,k_smooth];
    Results.binsz_smooth = binsz(i_smooth);
    Results.sfac_smooth = SmoothingFac(j_smooth);
    Results.drmethod_smooth = M1{k_smooth};
    Results.R2vals_smooth = evalR2(Xrec_all{i_smooth,j_smooth,k_smooth}(:,1:2),Xte_all{i_smooth,j_smooth,1}(:,1:2)); % final R2 for best solution (min KL)
    Results.Pcorr_smooth = evalCorrectTargets(Xrec_all{i_smooth,j_smooth,k_smooth}(:,1:2),normal(Xte_all{i_smooth,j_smooth,1}(:,1:2)),Tte_all{i_smooth,j_smooth,1});
    Results.Xte_smooth = Xte_all{i_smooth,j_smooth,1};
    Results.Tte_smooth = Tte_all{i_smooth,j_smooth,1};
    display(['Model = SmoothKL, R2 Value = ', num2str(Results.R2vals_smooth,2)])

    %% Model 3. maxR2 (supervised) (M)
    
    R2vals = zeros(length(binsz),length(SmoothingFac),length(M1));
    for k1=1:length(binsz)
        for k2=1:length(SmoothingFac)
            for k3=1:length(M1)
                L = size(Xrec_all{k1,k2,k3},1);
                M = round(L/2);
                tmp = find(diff(Tte_all{k1,k2,1}(M:end))); 

                if ~isempty(tmp)  
                    whichid = M + tmp(1)-1;
                else
                    error('Target vector is empty!')
                end

                trainid = 1:whichid;

                R2vals(k1,k2,k3)=evalR2(Xrec_all{k1,k2,k3}(trainid,1:2),Xte_all{k1,k2,1}(trainid,1:2));
                
            end
        end
    end

    [~,idd] = max(R2vals(:)); 
    [i_maxR2,j_maxR2,k_maxR2] = ind2sub(size(R2vals),idd);

    Results.coords_maxR2 = [i_maxR2,j_maxR2,k_maxR2];
    Results.binsz_maxR2 = binsz(i_maxR2);
    Results.sfac_maxR2 = SmoothingFac(j_maxR2);
    Results.drmethod_maxR2 = M1{k_maxR2};
    Results.R2vals_maxR2 = evalR2(Xrec_all{i_maxR2,j_maxR2,k_maxR2}(:,1:2),Xte_all{i_maxR2,j_maxR2,1}(:,1:2)); % final R2 for best solution (min KL)
    Results.Pcorr_maxR2 = evalCorrectTargets(Xrec_all{i_maxR2,j_maxR2,k_maxR2}(:,1:2),normal(Xte_all{i_maxR2,j_maxR2,1}(:,1:2)),Tte_all{i_maxR2,j_maxR2,1});
    Results.Xte_maxR2 = Xte_all{i_maxR2,j_maxR2,1};
    Results.Tte_maxR2 = Tte_all{i_maxR2,j_maxR2,1};    
    display(['Model = maxR2, R2 Value = ', num2str(Results.R2vals_maxR2,2)])

    %% Model 4. targetError (M)

    TargErr = zeros(length(binsz),length(SmoothingFac),length(M1));
    for k1=1:length(binsz)
        for k2=1:length(SmoothingFac)
            for k3=1:length(M1) 
                targvec = predictTargets(Xrec_all{k1,k2,k3},Xtr(:,1:2),Ttr);
                L = size(Xrec_all{k1,k2,k3},1);
                M = round(L/2);
                tmp = find(diff(Tte_all{k1,k2,1}(M:end))); 
                whichid = M + tmp(1)-1;
                trainid = 1:whichid;
                TargErr(k1,k2,k3) = sum( targvec(trainid) ~= Tte_all{k1,k2,1}(trainid) );
            end
        end
    end

    [~,idd] = min(TargErr(:)); 
    [i_maxTarg,j_maxTarg,k_maxTarg] = ind2sub(size(TargErr),idd);

    Results.coords_maxTarg = [i_maxTarg,j_maxTarg,k_maxTarg];
    Results.binsz_maxTarg = binsz(i_maxTarg);
    Results.sfac_maxTarg = SmoothingFac(j_maxTarg);
    Results.drmethod_maxTarg = M1{k_maxTarg};
    Results.R2vals_maxTarg = evalR2(Xrec_all{i_maxTarg,j_maxTarg,k_maxTarg}(:,1:2),Xte_all{i_maxTarg,j_maxTarg,1}(:,1:2)); % final R2 for best solution (min KL)
    Results.Pcorr_maxTarg = evalCorrectTargets(Xrec_all{i_maxTarg,j_maxTarg,k_maxTarg}(:,1:2),normal(Xte_all{i_maxTarg,j_maxTarg,1}(:,1:2)),Tte_all{i_maxTarg,j_maxTarg,1});
    Results.Xte_maxTarg = Xte_all{i_maxTarg,j_maxTarg,1};
    Results.Tte_maxTarg = Tte_all{i_maxTarg,j_maxTarg,1};    
    display(['Model = maxTarg, R2 Value = ', num2str(Results.R2vals_maxTarg,2)])

end % end if statement (switch over monkeys)


end % end function




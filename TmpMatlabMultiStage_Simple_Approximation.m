%%Gerardo Diaz Piche - Dissertation Msc Space Engineering
%DISCLAIMER: This has not been validated against real data. MIGHT CONTAIN
%ERRORS BEWARE

% References : A numerical study of the performance of a turbomolecular
% pump (https://www.researchgate.net/publication/240993092_A_numerical_study_of_the_performance_of_a_turbomolecular_pump)

%On the calculation of the overall transmission probability of a variable
%blade length multiple-stage turbomolecular pump
%(https://www.sciencedirect.com/science/article/pii/0042207X88902503?ref=pdf_download&fr=RR-2&rr=8c09d764893acd60)

clear
clc
% Main script part
[transmission_probability, overall_forward, overall_backward, compression_ratio] = turbomolecular_pump_multi_stage();

% Display the result
disp('Transmission probabilities for each stage:');
disp(transmission_probability);

disp('Overall Forward Transmission Probability:');
disp(overall_forward);

disp('Overall Backward Transmission Probability:');
disp(overall_backward);

disp('Compression Ratio (Forward / Backward):');
disp(compression_ratio);

% Function definition
function [transmission_probability, overall_forward, overall_backward, compression_ratio] = turbomolecular_pump_multi_stage()

    % Number of stages
    stages = 1;  %the userr can change this value depending on how many the TMP has

    % Define effective pumping areas and blocking areas for each stage
    A = [5.28616e-3, 5.28616e-3, 5.28616e-3, 5.28616e-3, 5.28616e-3, 5.28616e-3, 5.28616e-3, 5.28616e-3, 5.28616e-3, 5.28616e-3, 5.28616e-3];  % Effective pumping areas for each stage
    Ae = [4.04419e-3, 4.04419e-3, 4.04419e-3, 4.04419e-3, 4.04419e-3, 4.04419e-3, 4.04419e-3, 4.04419e-3, 4.04419e-3, 4.04419e-3, 4.04419e-3]; % Blocking areas for each stage

    % Define initial probabilities for forward and backward transmission
    P_forward = zeros(1, stages);  % eliminate P_forward(1) and in P_forward add an array with individual probabilities of every stage
                                   % here no array is being used as im
                                   % considering all the stages to have
                                   % same geometry and same probability
    P_forward(1) = 0.8596;  % Initial forward transmission probability at the first stage
    
    P_backward = zeros(1, stages);  %same as P_forward
    P_backward(1) = 0.0425; % Initial backward transmission probability at the first stage

    % Iterate over stages to compute the forward and backward transmission
    for j = 1:stages-1
        if j == 1
            % Special case for the first stage where j-1 is not valid
            numerator_forward = (A(j) + Ae(j)) * A(j) * P_forward(j);
            denominator_forward = (A(j) + Ae(j)) * A(j+1) + (A(j+1) + Ae(j+1)) * A(j) - A(j) * A(j+1);
            
            numerator_backward = (A(j+1) + Ae(j+1)) * A(j) * P_backward(j);
            denominator_backward = (A(j) + Ae(j)) * A(j+1) + (A(j+1) + Ae(j+1)) * A(j) - A(j) * A(j+1);
        else
            % Corrected Equations (7) and (8) for all other stages
            numerator_forward = (A(j-1) + Ae(j-1)) * A(j) * P_forward(j);
            denominator_forward = (A(j-1) + Ae(j-1)) * A(j+1) + (A(j+1) + Ae(j+1)) * A(j) - A(j) * A(j+1);
            
            numerator_backward = (A(j+1) + Ae(j+1)) * A(j-1) * P_backward(j);
            denominator_backward = (A(j-1) + Ae(j-1)) * A(j+1) + (A(j+1) + Ae(j+1)) * A(j-1) - A(j-1) * A(j+1);
        end

        % Calculate forward transmission probability
        if denominator_forward ~= 0
            P_forward(j+1) = numerator_forward / denominator_forward;
        else
            P_forward(j+1) = 0; % Avoid division by zero
        end

        % Calculate backward transmission probability
        if denominator_backward ~= 0
            P_backward(j+1) = numerator_backward / denominator_backward;
        else
            P_backward(j+1) = 0; % Avoid division by zero
        end
    end
    
    % Calculate the overall forward and backward transmission probabilities as products
    overall_forward = prod(P_forward);
    overall_backward = prod(P_backward);
    
    % Calculate the compression ratio (Forward / Backward)
    if overall_backward ~= 0
        compression_ratio = overall_forward / overall_backward;
    else
        compression_ratio = Inf;  % Avoid division by zero, set as infinity if backward probability is zero
    end 
    
    % Output the final transmission probability matrix after all stages
    transmission_probability = [P_forward; P_backward];
end

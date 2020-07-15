export BasicStructural

"""
"""
mutable struct BasicStructural{Fl} <: StateSpaceModel
    hyperparameters::HyperParameters{Fl}
    system::LinearUnivariateTimeInvariant{Fl}

    function BasicStructural(y::Vector{Fl}, s::Int) where Fl

        Z = [1; 0; 1; zeros(Fl, s - 2)]
        T = [
            1 1 zeros(Fl, 1, s - 1); 
            0 1 zeros(Fl, 1, s - 1);
            0 0 -ones(Fl, 1, s - 1);
            zeros(Fl, s - 2, 2) Matrix{Fl}(I, s - 2, s - 2) zeros(Fl, s - 2)
        ]
        R = [
            Matrix{Fl}(I, 3, 3); 
            zeros(Fl, s - 2, 3)
        ]
        d = zero(Fl)
        c = zeros(Fl, s + 1)
        H = one(Fl)
        Q = zeros(Fl, 3, 3)

        system = LinearUnivariateTimeInvariant{Fl}(y, Z, T, R, d, c, H, Q)

        names = ["sigma2_ε", "sigma2_μ", "sigma2_β", "sigma2_γ"]
        hyperparameters = HyperParameters{Fl}(names)

        return new{Fl}(hyperparameters, system)
    end
end

function default_filter(model::BasicStructural{Fl}) where Fl
    steadystate_tol = 1e-5
    a1 = zeros(Fl, get_num_states(model))
    P1 = 1e6 .* Matrix{Fl}(I, get_num_states(model), get_num_states(model))
    return UnivariateKalmanFilter(a1, P1, get_num_states(model), steadystate_tol)
end
function initial_hyperparameters!(model::BasicStructural{Fl}) where Fl
    initial_hyperparameters = Dict{String, Fl}(
        "sigma2_ε" => var(model.system.y),
        "sigma2_μ" => var(model.system.y),
        "sigma2_β" => one(Fl),
        "sigma2_γ" => one(Fl)
    )
    set_initial_hyperparameters!(model, initial_hyperparameters)
    return
end
function constraint_hyperparameters!(model::BasicStructural{Fl}) where Fl
    constrain_variance(model, "sigma2_ε")
    constrain_variance(model, "sigma2_μ")
    constrain_variance(model, "sigma2_β")
    constrain_variance(model, "sigma2_γ")
    return
end
function unconstraint_hyperparameters!(model::BasicStructural{Fl}) where Fl
    unconstrain_variance(model, "sigma2_ε")
    unconstrain_variance(model, "sigma2_μ")
    unconstrain_variance(model, "sigma2_β")
    unconstrain_variance(model, "sigma2_γ")
    return
end
function update!(model::BasicStructural{Fl}) where Fl
    model.system.H = get_constrained_value(model, "sigma2_ε")
    model.system.Q[1] = get_constrained_value(model, "sigma2_μ")
    model.system.Q[5] = get_constrained_value(model, "sigma2_β")
    model.system.Q[end] = get_constrained_value(model, "sigma2_γ")
    return 
end
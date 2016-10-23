function process_arg!(ds, srcs, helpers_ex, ::Val{:select}, ex, index)::Void
    res_field, value_ex = result_column(ex)
    f_ex, arg_fields = build_f_ex!(ds, srcs, value_ex, index)
    push!(
        helpers_ex.args,
        Expr(
            :call, Helper{:select}, Expr(:tuple, res_field, f_ex, arg_fields)
        )
    )
    return
end
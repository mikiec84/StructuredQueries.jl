macro summarize(tbl_name::Symbol, _exprs...)
    exprs = collect(_exprs)
    # check_for_summarize(exprs)
    summarize_helper_ex = _build_helper_ex(SummarizeNode, exprs)
    return quote
        g = SummarizeNode(DataNode($(esc(tbl_name))),
                          $exprs,
                          $summarize_helper_ex
        )
        _collect(g)
    end
end

macro summarize(_exprs...)
    exprs = collect(_exprs)
    summarize_helper_ex = _build_helper_ex(SummarizeNode, exprs)
    return quote
        g = SummarizeNode(DataNode(),
                          $exprs,
                          $summarize_helper_ex
        )
        _collect(CurryNode(), g)
    end
end

function check_for_summarize(exprs)
    for e in exprs
        @assert isa(e, Expr)
        @assert e.head == :kw
        @assert e.args[2].head == :call
    end
    return
end

function _build_helper_ex(::Type{SummarizeNode}, exprs)
    check_for_summarize(exprs)
    helper_parts_ex = Expr(:ref, :Tuple)
    for e in exprs
        col_name = _get_column_name(e)
        # Extract the first layer, which we assume is the summarization function
        new_e = e.args[2]
        @assert new_e.head == :call
        g_name = new_e.args[1]
        core_expr = new_e.args[2]
        kernel_expr, ind2sym = _build_anon_func(core_expr)
        push!(helper_parts_ex.args,
              Expr(
                :tuple,
                QuoteNode(col_name),
                kernel_expr,
                esc(g_name),
                ind2sym
              )
        )
    end
    return quote
        Helper{SummarizeNode}($helper_parts_ex)
    end
end

module TestQuery

using jplyr
using Base.Test

type MyData end

src = MyData()

n = 10
A = rand(n)
B = collect(1:n)
D = rand(["a", "b"], n)

# select

qrya = @query select(src, A)
qryb = @query src |> select(A)
@test isequal(qrya, qryb)

qrya = @query select(src, C = A * B)
qryb = @query src |> select(C = A * B)
@test isequal(qrya, qryb)

qrya = @query select(src, A, C = A * B)
qryb = @query src |> select(A, C = A * B)
@test isequal(qrya, qryb)

# filter

qrya = @query filter(src, A > .5)
qryb = @query src |> filter(A > .5)
@test isequal(qrya, qryb)

# groupby

qrya = @query groupby(src, D)
qryb = @query src |> groupby(D)
@test isequal(qrya, qryb)

qrya = @query groupby(src, A > .5)
qryb = @query src |> groupby(A > .5)
@test isequal(qrya, qryb)

qrya = @query groupby(src, D, A > .5)
qryb = @query src |> groupby(D, A > .5)
@test isequal(qrya, qryb)

# summarize

qrya = @query summarize(src, avg_A = mean(A))
qryb = @query src |> summarize(avg_A = mean(A))
@test isequal(qrya, qryb)

end

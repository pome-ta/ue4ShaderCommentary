# ue4ShaderCommentary
> ue マテリアルと、Shader


書き方を定義したいと思います 😇<br>
ノード(関数)と、ピン、ワイヤーを、文字で表現してみる試み

> 複雑なことを書かないと思うので、便宜的に(ワイちゃんオリジナル)


## 表記例

``` .hs
[<in: ピン> "ノード(関数)名" <out: ピン>]

```



### 具体例

``` .hs

[ "TexCoord" <(r, g)>] -> [<final_color: (r, g)> "最終出力"]
```

ピンの`in` ,`out` の名前で繋ぐ的な

この場合だと、`TexCoord` の`out` にあるピンは、2つの値がある(`r = U` , `g = V` )

`最終出力` の`final color` は、`R,G,B` 値を受け取れる。`r = R` ,`g = G` を`TexCoord` の数値から貰ってくる

> SyntaxHighlight 上、`in` `out` の名前で間にスペースがあるものは、`_` で繋いでる(スネークケース)





#!/usr/bin/env bash
# 作業中インジケータの 1 フレームを出力する。
# tmux の window-status-format から status-interval（=1秒）ごとに呼ばれ、
# ドット送り＋色のゆっくり変化（緑→青緑→青→…）でアニメーションする。
# フレーム/色は epoch 秒で選ぶ（外部コマンドの fork を避けるため bash の
# printf '%(%s)T' を使い、未対応の古い bash では date にフォールバック）。
#
# 出力には tmux のスタイル指定 #[fg=...] を含む（window-status 側で解釈される）。

frames=('.  ' '.. ' '...' ' ..' '  .' '   ')
colors=('#9ece6a' '#8bd5a0' '#73daca' '#7dcfff' '#73daca' '#8bd5a0')

now=$(printf '%(%s)T' -1 2>/dev/null) || now=$(date +%s)
n=${#frames[@]}
i=$(( now % n ))

printf '#[fg=%s]%s' "${colors[$i]}" "${frames[$i]}"

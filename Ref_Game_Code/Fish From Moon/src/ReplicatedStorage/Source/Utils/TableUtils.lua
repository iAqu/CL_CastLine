local TableUtils = {}

---获得数组的长度
function TableUtils.getTableLegth(t)
    local total = 0
    for key, value in pairs(t) do
        total = total + 1
    end
    return total
end

return TableUtils

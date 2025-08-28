// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

//反转一个字符串。输入 "abcde"，输出 "edcba"

/**
 * @title 合约名称
 * @author 作者名
 * @notice 功能说明
 * @dev 开发者说明
 */
contract Reverse {
    function reverseStr(string memory str) public pure returns (string memory) {
        bytes memory b = bytes(str);
        bytes memory reversed = new bytes(b.length);
        uint256 len = b.length;
        for (uint256 i = 0; i < len; i++) {
            reversed[i] = b[len - 1 - i];
        }
        return string(reversed);
    }

    function toRoman(uint256 num) public pure returns (string memory) {
        if (num == 0) {
            return "";
        }

        uint256[13] memory values = [
            uint256(1000),
            900,
            500,
            400,
            100,
            90,
            50,
            40,
            10,
            9,
            5,
            4,
            1
        ];
        string[13] memory symbols = [
            "M",
            "CM",
            "D",
            "CD",
            "C",
            "XC",
            "L",
            "XL",
            "X",
            "IX",
            "V",
            "IV",
            "I"
        ];

        string memory result = "";

        for (uint256 i = 0; i < values.length; i++) {
            while (num >= values[i]) {
                result = string(abi.encodePacked(result, symbols[i]));
                num -= values[i];
            }
        }

        return result;
    }
    // 合并两个有序数组 (Merge Sorted Array)
    function mergeSortedArrays(uint256[] memory arr1, uint256[] memory arr2)
        public
        pure
        returns (uint256[] memory)
    {
        uint256 len1 = arr1.length;
        uint256 len2 = arr2.length;
        uint256[] memory mergedArr = new uint256[](len1 + len2);

        uint256 index1 = 0;
        uint256 index2 = 0;
        uint256 mergeIndex = 0;

        while (index1 < len1 && index2 < len2) {
            if (arr1[index1] <= arr2[index2]) {
                mergedArr[mergeIndex] = arr1[index1];
                index1++;
            } else {
                mergedArr[mergeIndex] = arr2[index2];
                index2++;
            }
            mergeIndex++;
        }
        while (index1 < len1) {
            mergedArr[mergeIndex] = arr1[index1];
            index1++;
            mergeIndex++;
        }
        while (index2 < len2) {
            mergedArr[mergeIndex] = arr2[index2];
            index2++;
            mergeIndex++;
        }

        return mergedArr;
    }
    //在一个有序数组中查找目标值。
    function binarySearch(uint256[] memory arr, uint256 target)
        public
        pure
        returns (int256)
    {
        require(arr.length > 0);

        uint256 left = 0;
        uint256 right = arr.length - 1;

        while (left <= right) {
            uint256 mid = (left + right) / 2;
            if (arr[mid] == target) {
                return int256(mid);
            } else if (arr[mid] < target) {
                left = mid + 1;
            } else {
                // 防止下溢
                if (mid == 0) {
                    break;
                }
                right = mid - 1; // 目标在左半部分
            }
        }
        return -1;
    }
}

import { describe, it, expect } from "vitest";

// Timeline positioning test cases
describe("Timeline Positioning", () => {
  const testCases = [
    { date: "2024-02-22", day: 22, monthsBefore: 18, expected: 1260 },
    { date: "2021-02-25", day: 25, monthsBefore: 54, expected: 3706 },
    // Add more test cases as needed
    { date: "2025-06-26", day: 26, monthsBefore: 2, expected: 168 }, // Your original June example
  ];

  // Current formula parameters
  let effectiveMonthHeight = 68;
  let baseOffset = 22;
  let dayFormulaBase = 60;

  function calculatePosition(monthsBefore, day) {
    const monthComponent = monthsBefore * effectiveMonthHeight;
    const dayComponent = dayFormulaBase - day * 2;
    return monthComponent + dayComponent + baseOffset;
  }

  function runTests() {
    console.log("🧪 Timeline Positioning Tests");
    console.log("==============================");

    let passCount = 0;
    let totalTests = testCases.length;

    testCases.forEach((testCase) => {
      const calculated = calculatePosition(testCase.monthsBefore, testCase.day);
      const difference = calculated - testCase.expected;
      const passed = Math.abs(difference) <= 2; // Allow 2px tolerance

      console.log(`📍 ${testCase.date} (day ${testCase.day}):`);
      console.log(`   Expected: ${testCase.expected}px`);
      console.log(`   Calculated: ${calculated}px`);
      console.log(`   Difference: ${difference > 0 ? "+" : ""}${difference}px`);
      console.log(`   Status: ${passed ? "✅ PASS" : "❌ FAIL"}`);
      console.log("");

      if (passed) passCount++;
    });

    console.log(`📊 Results: ${passCount}/${totalTests} tests passed`);

    if (passCount < totalTests) {
      console.log("💡 Suggested adjustments:");
      // Analyze patterns in failures to suggest formula adjustments
      analyzeFailures();
    }

    return passCount === totalTests;
  }

  function analyzeFailures() {
    const failures = testCases
      .map((testCase) => {
        const calculated = calculatePosition(
          testCase.monthsBefore,
          testCase.day
        );
        return {
          ...testCase,
          calculated,
          difference: calculated - testCase.expected,
        };
      })
      .filter((test) => Math.abs(test.difference) > 2);

    if (failures.length === 0) return;

    const avgDifference =
      failures.reduce((sum, f) => sum + f.difference, 0) / failures.length;

    if (Math.abs(avgDifference) > 1) {
      console.log(
        `   - Adjust baseOffset by ${-Math.round(
          avgDifference
        )}px (currently ${baseOffset})`
      );
    }

    // Check if older events have larger errors (suggests month spacing issue)
    const oldestFailure = failures.reduce((oldest, current) =>
      current.monthsBefore > oldest.monthsBefore ? current : oldest
    );
    const newestFailure = failures.reduce((newest, current) =>
      current.monthsBefore < newest.monthsBefore ? current : newest
    );

    if (
      failures.length > 1 &&
      oldestFailure.monthsBefore !== newestFailure.monthsBefore
    ) {
      const errorGrowth = oldestFailure.difference - newestFailure.difference;
      const monthDifference =
        oldestFailure.monthsBefore - newestFailure.monthsBefore;
      const errorPerMonth = errorGrowth / monthDifference;

      if (Math.abs(errorPerMonth) > 0.1) {
        const suggestedMonthHeight = effectiveMonthHeight - errorPerMonth;
        console.log(
          `   - Adjust effectiveMonthHeight to ${suggestedMonthHeight.toFixed(
            1
          )}px (currently ${effectiveMonthHeight})`
        );
      }
    }
  }

  // Individual test cases for better Vitest reporting
  testCases.forEach((testCase) => {
    it(`should correctly position ${testCase.date} (day ${testCase.day})`, () => {
      const calculated = calculatePosition(testCase.monthsBefore, testCase.day);
      const difference = Math.abs(calculated - testCase.expected);

      expect(difference).toBeLessThanOrEqual(2); // Allow 2px tolerance

      // Log details for debugging
      console.log(
        `📍 ${testCase.date}: expected ${
          testCase.expected
        }px, got ${calculated}px (diff: ${calculated - testCase.expected}px)`
      );
    });
  });

  // Overall test that runs all checks and provides analysis
  it("should pass all positioning tests with analysis", () => {
    expect(runTests()).toBe(true);
  });
});

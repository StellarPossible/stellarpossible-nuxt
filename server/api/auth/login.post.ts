interface TestResult {
  test: string
  status: 'success' | 'failed'
  data?: any
  error?: {
    message: string
    status?: number
    statusCode?: number
    cause?: any
  }
}

interface TestResults {
  endpoint: string
  tests: TestResult[]
}

export default defineEventHandler(async (event): Promise<TestResults> => {
  const config = useRuntimeConfig()
  const wpEndpoint = config.public.wpRestEndpoint || 'https://stellarpossible.com/wp-json'
  
  const testResults: TestResults = {
    endpoint: wpEndpoint,
    tests: []
  }
  
  // Test 1: Basic WordPress API connectivity
  try {
    const response = await $fetch(`${wpEndpoint}/`, {
      timeout: 10000
    })
    
    testResults.tests.push({
      test: 'WordPress API Basic Connectivity',
      status: 'success',
      data: {
        name: response.name || 'WordPress Site',
        description: response.description || 'No description',
        routes: response.routes ? Object.keys(response.routes).length : 0
      }
    })
  } catch (error: any) {
    testResults.tests.push({
      test: 'WordPress API Basic Connectivity',
      status: 'failed',
      error: {
        message: error.message,
        status: error.status || error.statusCode,
        cause: error.cause?.code || error.code
      }
    })
  }
  
  // Test 2: Detailed password analysis
  if (config.wpAppPassword) {
    const password = config.wpAppPassword
    const passwordChars = password.split('').map((char, index) => ({
      index,
      char: char === ' ' ? 'SPACE' : char,
      charCode: char.charCodeAt(0)
    }))
    
    testResults.tests.push({
      test: 'Password Analysis',
      status: 'success',
      data: {
        originalLength: password.length,
        withoutSpacesLength: password.replace(/\s/g, '').length,
        hasSpaces: password.includes(' '),
        startsWithSpace: password.startsWith(' '),
        endsWithSpace: password.endsWith(' '),
        spaceCount: (password.match(/\s/g) || []).length,
        firstFiveChars: passwordChars.slice(0, 5),
        lastFiveChars: passwordChars.slice(-5)
      }
    })
  }
  
  // Test 3: Try multiple password formats
  if (config.public.wpUser && config.wpAppPassword) {
    const passwordVariations = [
      { name: 'original', value: config.wpAppPassword },
      { name: 'trimmed', value: config.wpAppPassword.trim() },
      { name: 'no-spaces', value: config.wpAppPassword.replace(/\s/g, '') },
      { name: 'single-spaces', value: config.wpAppPassword.replace(/\s+/g, ' ') }
    ]
    
    for (const variation of passwordVariations) {
      try {
        const authString = Buffer.from(`${config.public.wpUser}:${variation.value}`).toString('base64')
        
        const response = await $fetch(`${wpEndpoint}/wp/v2/users/me`, {
          headers: {
            'Authorization': `Basic ${authString}`,
            'Content-Type': 'application/json'
          },
          timeout: 8000
        })
        
        testResults.tests.push({
          test: `Auth Success (${variation.name})`,
          status: 'success',
          data: {
            user: response.username,
            email: response.email,
            roles: response.roles,
            passwordVariation: variation.name,
            passwordLength: variation.value.length
          }
        })
        
        // If one works, we can stop testing
        break
        
      } catch (error: any) {
        testResults.tests.push({
          test: `Auth Test (${variation.name})`,
          status: 'failed',
          error: {
            message: error.message,
            status: error.status || error.statusCode,
            passwordVariation: variation.name,
            passwordLength: variation.value.length
          }
        })
      }
    }
  }
  
  // Test 4: Manual credential test (hardcoded for debugging)
  try {
    // Test with a known good format - replace with your actual credentials
    const testAuthString = Buffer.from('mlvalentonis:UBQmj2mBAAGYcTlRX6zoySns').toString('base64')
    
    const response = await $fetch(`${wpEndpoint}/wp/v2/users/me`, {
      headers: {
        'Authorization': `Basic ${testAuthString}`,
        'Content-Type': 'application/json'
      },
      timeout: 8000
    })
    
    testResults.tests.push({
      test: 'Manual Credential Test',
      status: 'success',
      data: {
        user: response.username,
        email: response.email,
        roles: response.roles,
        note: 'Hardcoded credentials work'
      }
    })
    
  } catch (error: any) {
    testResults.tests.push({
      test: 'Manual Credential Test',
      status: 'failed',
      error: {
        message: error.message,
        status: error.status || error.statusCode,
        note: 'Even hardcoded credentials fail'
      }
    })
  }
  
  // Test 5: Check WordPress user capabilities
  try {
    const response = await $fetch(`${wpEndpoint}/wp/v2/users`, {
      query: {
        search: 'mlvalentonis',
        per_page: 1
      },
      timeout: 8000
    })
    
    testResults.tests.push({
      test: 'User Lookup (Public)',
      status: 'success',
      data: {
        found: response.length > 0,
        user: response[0] ? {
          id: response[0].id,
          username: response[0].username,
          name: response[0].name,
          roles: response[0].roles
        } : null
      }
    })
    
  } catch (error: any) {
    testResults.tests.push({
      test: 'User Lookup (Public)',
      status: 'failed',
      error: {
        message: error.message,
        status: error.status || error.statusCode
      }
    })
  }
  
  return testResults
})
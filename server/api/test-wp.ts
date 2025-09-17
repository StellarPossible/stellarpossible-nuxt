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
  
  // Test 1: Basic connectivity
  try {
    const response = await $fetch(`${wpEndpoint}/`, {
      timeout: 10000
    })
    testResults.tests.push({
      test: 'Basic API connectivity',
      status: 'success',
      data: {
        name: response.name || 'Unknown',
        description: response.description || 'No description',
        url: response.url || 'No URL',
        routes: Object.keys(response.routes || {}).length
      }
    })
  } catch (error: any) {
    testResults.tests.push({
      test: 'Basic API connectivity',
      status: 'failed',
      error: {
        message: error.message,
        status: error.status,
        statusCode: error.statusCode,
        cause: error.cause?.code || error.code
      }
    })
  }
  
  // Test 2: WordPress v2 API endpoint
  try {
    const response = await $fetch(`${wpEndpoint}/wp/v2/`, {
      timeout: 10000
    })
    testResults.tests.push({
      test: 'WordPress v2 API endpoint',
      status: 'success',
      data: {
        message: 'WordPress REST API v2 is accessible',
        routes: Object.keys(response.routes || {}).length
      }
    })
  } catch (error: any) {
    testResults.tests.push({
      test: 'WordPress v2 API endpoint',
      status: 'failed',
      error: {
        message: error.message,
        status: error.status,
        statusCode: error.statusCode,
        cause: error.cause?.code || error.code
      }
    })
  }
  
  // Test 3: Admin authentication
  if (config.public.wpUser && config.wpAppPassword) {
    try {
      const response = await $fetch(`${wpEndpoint}/wp/v2/users/me`, {
        headers: {
          'Authorization': `Basic ${Buffer.from(`${config.public.wpUser}:${config.wpAppPassword}`).toString('base64')}`,
          'Content-Type': 'application/json'
        },
        timeout: 10000
      })
      testResults.tests.push({
        test: 'Admin authentication',
        status: 'success',
        data: {
          user: response.username,
          roles: response.roles,
          id: response.id
        }
      })
    } catch (error: any) {
      testResults.tests.push({
        test: 'Admin authentication',
        status: 'failed',
        error: {
          message: error.message,
          status: error.status,
          statusCode: error.statusCode,
          cause: error.cause?.code || error.code
        }
      })
    }
    
    // Test 4: Users endpoint access
    try {
      const response = await $fetch(`${wpEndpoint}/wp/v2/users`, {
        headers: {
          'Authorization': `Basic ${Buffer.from(`${config.public.wpUser}:${config.wpAppPassword}`).toString('base64')}`,
          'Content-Type': 'application/json'
        },
        query: {
          per_page: 1
        },
        timeout: 10000
      })
      testResults.tests.push({
        test: 'Users endpoint access',
        status: 'success',
        data: {
          message: `Users endpoint accessible, found ${response.length} user(s) in sample`,
          totalUsers: response.length > 0 ? 'At least 1' : '0'
        }
      })
    } catch (error: any) {
      testResults.tests.push({
        test: 'Users endpoint access',
        status: 'failed',
        error: {
          message: error.message,
          status: error.status,
          statusCode: error.statusCode,
          cause: error.cause?.code || error.code
        }
      })
    }
  } else {
    testResults.tests.push({
      test: 'Admin credentials check',
      status: 'failed',
      error: {
        message: 'WordPress admin credentials not configured',
        status: 0,
        statusCode: 0
      }
    })
  }
  
  // Test 5: Alternative endpoints
  const alternativeEndpoints = [
    'https://www.stellarpossible.com/wp-json',
    'https://stellarpossible.com/index.php/wp-json'
  ]
  
  for (const altEndpoint of alternativeEndpoints) {
    if (altEndpoint === wpEndpoint) continue // Skip the main endpoint we already tested
    
    try {
      const response = await $fetch(`${altEndpoint}/`, {
        timeout: 5000
      })
      testResults.tests.push({
        test: `Alternative endpoint: ${altEndpoint}`,
        status: 'success',
        data: {
          name: response.name || 'Unknown',
          message: 'Alternative endpoint is accessible'
        }
      })
    } catch (error: any) {
      testResults.tests.push({
        test: `Alternative endpoint: ${altEndpoint}`,
        status: 'failed',
        error: {
          message: error.message,
          status: error.status,
          statusCode: error.statusCode,
          cause: error.cause?.code || error.code
        }
      })
    }
  }
  
  return testResults
})
import api from './api';

export const login = async (phone, password) => {
    try {
        const response = await api.post('/auth/login', { phone, password });
        if (response.data.access_token) {
            localStorage.setItem('auth_token', response.data.access_token);
            localStorage.setItem('user_data', JSON.stringify({
                id: response.data.user_id,
                name: response.data.full_name,
                phone: response.data.phone,
                language: response.data.language
            }));
        }
        return response.data;
    } catch (error) {
        throw error.response?.data?.detail || error.message || 'Login failed';
    }
};

export const register = async (userData) => {
    try {
        // userData: { phone, full_name, language, password }
        const response = await api.post('/auth/register', userData);
        return response.data;
    } catch (error) {
        throw error.response?.data?.detail || error.message || 'Registration failed';
    }
};

export const verifyOtp = async (phone, otp) => {
    try {
        const response = await api.post('/auth/verify-otp', { phone, otp });
        if (response.data.access_token) {
            localStorage.setItem('auth_token', response.data.access_token);
            // We might need to fetch user profile here if verify-otp doesn't return full details
            // But based on my changes, it DOES return details now!
            localStorage.setItem('user_data', JSON.stringify({
                id: response.data.user_id,
                name: response.data.full_name,
                phone: response.data.phone,
                language: response.data.language
            }));
        }
        return response.data;
    } catch (error) {
        throw error.response?.data?.detail || error.message || 'Verification failed';
    }
};

export const logout = () => {
    localStorage.removeItem('auth_token');
    localStorage.removeItem('user_data');
    window.location.href = '/login';
};

export const getCurrentUser = () => {
    const userStr = localStorage.getItem('user_data');
    return userStr ? JSON.parse(userStr) : null;
};

export const isAuthenticated = () => {
    return !!localStorage.getItem('auth_token');
};

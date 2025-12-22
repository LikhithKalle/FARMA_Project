import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { getCurrentUser, logout } from '../services/auth';
import { Sun, Wind, Droplets, Leaf, LogOut, MessageSquare } from 'lucide-react';

const Dashboard = () => {
    const [user, setUser] = useState(null);
    const [greeting, setGreeting] = useState('');
    const navigate = useNavigate();

    useEffect(() => {
        const userData = getCurrentUser();
        if (!userData) {
            navigate('/login');
            return;
        }
        setUser(userData);

        // Set greeting
        const hour = new Date().getHours();
        if (hour < 12) setGreeting('Good Morning');
        else if (hour < 17) setGreeting('Good Afternoon');
        else setGreeting('Good Evening');
    }, [navigate]);

    const handleLogout = () => {
        logout();
    };

    if (!user) return null;

    return (
        <div className="min-h-screen bg-dark text-white">
            {/* Header */}
            <header className="px-6 py-6 flex items-center justify-between border-b border-white/5">
                <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-primary/20 rounded-full flex items-center justify-center">
                        <span className="text-xl">🌿</span>
                    </div>
                    <span className="font-bold text-xl tracking-wide">FARM INTELLIGENCE</span>
                </div>

                <div className="flex items-center gap-4">
                    <div className="text-right hidden md:block">
                        <p className="text-xs text-gray-400">Welcome</p>
                        <p className="font-semibold text-primary">{user.name}</p>
                    </div>
                    <button
                        onClick={handleLogout}
                        className="p-2 hover:bg-white/5 rounded-full text-red-400 transition-colors"
                        title="Logout"
                    >
                        <LogOut size={20} />
                    </button>
                </div>
            </header>

            <main className="container mx-auto px-4 py-8 max-w-5xl">
                {/* Welcome Section */}
                <section className="mb-8">
                    <h2 className="text-gray-400 text-lg font-medium">{greeting},</h2>
                    <h1 className="text-4xl font-bold mt-1 capitalize">{user.name}</h1>
                </section>

                {/* Weather Card (Placeholder for now) */}
                <section className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                    <div className="bg-[#1A3826] p-6 rounded-2xl border border-white/5 flex items-center justify-between col-span-2">
                        <div>
                            <div className="flex items-center gap-2 text-primary mb-2">
                                <Sun size={20} />
                                <span className="font-medium">Sunny</span>
                            </div>
                            <div className="text-5xl font-bold mb-1">28°C</div>
                            <div className="text-gray-400 text-sm">Nashik, Maharashtra</div>
                        </div>
                        <div className="text-right space-y-3">
                            <div className="flex items-center justify-end gap-2 text-sm text-gray-300">
                                <Wind size={16} />
                                <span>12 km/h</span>
                            </div>
                            <div className="flex items-center justify-end gap-2 text-sm text-gray-300">
                                <Droplets size={16} />
                                <span>45%</span>
                            </div>
                        </div>
                    </div>

                    <div className="bg-primary p-6 rounded-2xl text-dark flex flex-col justify-between cursor-pointer hover:bg-[#0fdc60] transition-colors relative overflow-hidden group">
                        <div className="absolute right-[-20px] bottom-[-20px] opacity-10 group-hover:scale-110 transition-transform duration-500">
                            <Leaf size={120} />
                        </div>
                        <div>
                            <h3 className="font-bold text-lg mb-1">Crop Guide</h3>
                            <p className="text-dark/70 text-sm">Best practices for your farm</p>
                        </div>
                        <button className="bg-dark/10 w-10 h-10 rounded-full flex items-center justify-center mt-4">
                            →
                        </button>
                    </div>
                </section>

                {/* Chat / Assistant Access */}
                <section>
                    <div className="bg-gradient-to-br from-[#1A3826] to-[#0D1C13] p-8 rounded-3xl border border-green-500/20 text-center relative overflow-hidden">

                        <div className="relative z-10 max-w-xl mx-auto">
                            <h3 className="text-2xl font-bold mb-2">What are we planting today?</h3>
                            <p className="text-gray-400 mb-8">Ask our AI assistant for crop recommendations, disease diagnosis, or farming advice.</p>

                            <button
                                onClick={() => alert("Chat feature coming next!")}
                                className="bg-primary text-dark font-bold text-lg px-8 py-4 rounded-full flex items-center gap-3 mx-auto hover:bg-[#0fdc60] hover:scale-105 transition-all shadow-lg shadow-green-500/20"
                            >
                                <MessageSquare size={24} />
                                Start Conversation
                            </button>
                        </div>
                    </div>
                </section>
            </main>
        </div>
    );
};

export default Dashboard;

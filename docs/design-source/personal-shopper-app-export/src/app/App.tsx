import React, { useState } from 'react';
import { 
  Package, 
  ChevronRight, 
  FileText, 
  Check, 
  X, 
  Truck, 
  ArrowRight,
  Clock,
  Smartphone,
  Plus,
  ArrowLeft,
  Box,
  MapPin,
  TrendingUp,
  Users,
  Image as ImageIcon,
  ChevronDown,
  User,
  ShoppingBag,
  Shield,
  CheckCircle2,
  Settings,
  LogOut,
  Lock,
  Mail,
  Phone
} from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';

// --- Types ---
type Role = 'CLIENT' | 'SHOPPER' | 'LOGISTICS' | 'ADMIN';

type Status = 
  | 'SUBMITTED' 
  | 'QUOTE_AVAILABLE' 
  | 'QUOTE_ACCEPTED' 
  | 'PAID' 
  | 'PURCHASED' 
  | 'WAREHOUSE_RECEIVED'
  | 'INTERNATIONAL_TRANSIT'
  | 'ARRIVED_IN_MADAGASCAR'
  | 'DELIVERED';

interface ProductRequest {
  id: string;
  title: string;
  url: string;
  imageUrl?: string;
  priceEstimate?: number;
  status: Status;
  quote?: Quote;
}

interface Quote {
  productAmount: number;
  exchangeRate: number;
  serviceFee: number;
  localDeliveryFee: number;
  totalMGA: number;
}

interface UserProfile {
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
}

// --- Mock Data ---
const initialRequests: ProductRequest[] = [
  {
    id: 'REQ-001',
    title: 'Apple iPhone 15 Pro - 256GB - Blue Titanium',
    url: 'https://apple.com/iphone-15-pro',
    imageUrl: 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&q=80&w=400',
    status: 'QUOTE_AVAILABLE',
    quote: {
      productAmount: 1099,
      exchangeRate: 4600,
      serviceFee: 50000,
      localDeliveryFee: 15000,
      totalMGA: 5120400,
    }
  },
  {
    id: 'REQ-002',
    title: 'Sony WH-1000XM5 Wireless Headphones',
    url: 'https://amazon.fr/sony-headphones',
    imageUrl: 'https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?auto=format&fit=crop&q=80&w=400',
    status: 'SUBMITTED'
  },
  {
    id: 'REQ-003',
    title: 'Nike Air Force 1 \'07 - Size 42',
    url: 'https://nike.com/air-force-1',
    imageUrl: 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?auto=format&fit=crop&q=80&w=400',
    status: 'PURCHASED',
    quote: {
      productAmount: 110,
      exchangeRate: 4600,
      serviceFee: 20000,
      localDeliveryFee: 10000,
      totalMGA: 536000,
    }
  },
  {
    id: 'REQ-004',
    title: 'Logitech MX Master 3S',
    url: 'https://amazon.fr/logitech-mx',
    imageUrl: 'https://images.unsplash.com/photo-1615663245857-ac1eeb536bfb?auto=format&fit=crop&q=80&w=400',
    status: 'ARRIVED_IN_MADAGASCAR',
    quote: {
      productAmount: 90,
      exchangeRate: 4600,
      serviceFee: 20000,
      localDeliveryFee: 10000,
      totalMGA: 444000,
    }
  }
];

// --- App Component ---
export default function App() {
  const [role, setRole] = useState<Role>('CLIENT');
  const [requests, setRequests] = useState<ProductRequest[]>(initialRequests);
  const [view, setView] = useState<'LIST' | 'NEW_REQUEST' | 'QUOTE_REVIEW' | 'PAYMENT' | 'QUOTE_CREATE' | 'ACCOUNT_SETTINGS'>('LIST');
  const [activeRequest, setActiveRequest] = useState<ProductRequest | null>(null);
  const [isSwitcherOpen, setIsSwitcherOpen] = useState(false);
  const [accountSection, setAccountSection] = useState<'PROFILE' | 'SECURITY' | 'MONEY' | 'ADDRESSES'>('PROFILE');
  const [userProfile, setUserProfile] = useState<UserProfile>({
    firstName: 'Jean',
    lastName: 'Rakoto',
    email: 'jean.rakoto@example.com',
    phone: '+261 34 00 000 00'
  });

  // --- Handlers ---
  const handleCreateRequest = (e: React.FormEvent) => {
    e.preventDefault();
    const formData = new FormData(e.target as HTMLFormElement);
    const newReq: ProductRequest = {
      id: `REQ-00${requests.length + 1}`,
      title: formData.get('title') as string,
      url: formData.get('url') as string,
      // Fallback placeholder for newly created requests without fetched images
      imageUrl: '', 
      status: 'SUBMITTED',
    };
    setRequests([newReq, ...requests]);
    setView('LIST');
  };

  const handleAcceptQuote = (req: ProductRequest) => {
    setActiveRequest(req);
    setView('PAYMENT');
  };

  const handlePayment = () => {
    if (!activeRequest) return;
    setRequests(requests.map(r => r.id === activeRequest.id ? { ...r, status: 'PAID' } : r));
    setView('LIST');
  };

  const handleCreateQuote = (e: React.FormEvent) => {
    e.preventDefault();
    if (!activeRequest) return;
    const formData = new FormData(e.target as HTMLFormElement);
    const productAmount = Number(formData.get('productAmount'));
    const exchangeRate = Number(formData.get('exchangeRate'));
    const serviceFee = Number(formData.get('serviceFee'));
    const localDeliveryFee = Number(formData.get('localDeliveryFee'));
    
    const quote: Quote = {
      productAmount,
      exchangeRate,
      serviceFee,
      localDeliveryFee,
      totalMGA: (productAmount * exchangeRate) + serviceFee + localDeliveryFee
    };

    setRequests(requests.map(r => r.id === activeRequest.id ? { ...r, status: 'QUOTE_AVAILABLE', quote } : r));
    setView('LIST');
  };

  const updateStatus = (id: string, newStatus: Status) => {
    setRequests(requests.map(r => r.id === id ? { ...r, status: newStatus } : r));
  };

  const handleUpdateProfile = (e: React.FormEvent) => {
    e.preventDefault();
    const formData = new FormData(e.target as HTMLFormElement);
    setUserProfile({
      firstName: formData.get('firstName') as string,
      lastName: formData.get('lastName') as string,
      email: formData.get('email') as string,
      phone: formData.get('phone') as string,
    });
    // Visual feedback could be added here, but staying seamless for now
  };

  const handleUpdatePassword = (e: React.FormEvent) => {
    e.preventDefault();
    const form = e.target as HTMLFormElement;
    form.reset();
    // Simulate password update
  };

  // --- UI Helpers ---
  const StatusBadge = ({ status }: { status: Status }) => {
    const configs: Record<Status, { color: string, label: string }> = {
      SUBMITTED: { color: 'bg-zinc-100 text-zinc-600', label: 'Pending Quote' },
      QUOTE_AVAILABLE: { color: 'bg-blue-50 text-blue-700', label: 'Quote Ready' },
      QUOTE_ACCEPTED: { color: 'bg-zinc-100 text-zinc-800', label: 'Awaiting Payment' },
      PAID: { color: 'bg-green-50 text-green-700', label: 'Paid' },
      PURCHASED: { color: 'bg-orange-50 text-orange-700', label: 'Purchased' },
      WAREHOUSE_RECEIVED: { color: 'bg-purple-50 text-purple-700', label: 'At Warehouse' },
      INTERNATIONAL_TRANSIT: { color: 'bg-indigo-50 text-indigo-700', label: 'In Transit' },
      ARRIVED_IN_MADAGASCAR: { color: 'bg-teal-50 text-teal-700', label: 'Arrived Tana' },
      DELIVERED: { color: 'bg-black text-white', label: 'Delivered' }
    };
    const conf = configs[status];
    return (
      <span className={`px-3 py-1 text-[12px] font-semibold tracking-wide rounded-full ${conf.color}`}>
        {conf.label}
      </span>
    );
  };

  const TrackingProgress = ({ status }: { status: Status }) => {
    const progressMap: Record<Status, number> = {
      SUBMITTED: 0, QUOTE_AVAILABLE: 0, QUOTE_ACCEPTED: 0, 
      PAID: 10, 
      PURCHASED: 25, 
      WAREHOUSE_RECEIVED: 50, 
      INTERNATIONAL_TRANSIT: 75, 
      ARRIVED_IN_MADAGASCAR: 90, 
      DELIVERED: 100
    };
    
    const labelMap: Record<Status, string> = {
      SUBMITTED: '', QUOTE_AVAILABLE: '', QUOTE_ACCEPTED: '', 
      PAID: 'Payment confirmed. Shopper preparing to buy.', 
      PURCHASED: 'Item purchased. Awaiting delivery to overseas warehouse.', 
      WAREHOUSE_RECEIVED: 'Received at overseas warehouse. Preparing for shipment.', 
      INTERNATIONAL_TRANSIT: 'In transit to Madagascar. Expected soon.', 
      ARRIVED_IN_MADAGASCAR: 'Arrived in Antananarivo. Ready for local dispatch.', 
      DELIVERED: 'Package delivered.'
    };

    const pct = progressMap[status] || 0;
    if (pct === 0) return null;

    return (
      <div className="mt-4 w-full sm:max-w-md">
        <div className="flex justify-between items-center text-[13px] font-medium text-zinc-500 mb-2">
          <span>{labelMap[status]}</span>
        </div>
        <div className="h-1.5 w-full bg-zinc-100 rounded-full overflow-hidden">
          <motion.div 
            initial={{ width: 0 }} 
            animate={{ width: `${pct}%` }} 
            transition={{ duration: 1, ease: "easeOut" }}
            className="h-full bg-black rounded-full" 
          />
        </div>
      </div>
    );
  };

  // Animation variants
  const pageVariants = {
    initial: { opacity: 0, y: 12, scale: 0.99 },
    animate: { opacity: 1, y: 0, scale: 1, transition: { duration: 0.4, ease: [0.22, 1, 0.36, 1] } },
    exit: { opacity: 0, y: -8, scale: 0.99, transition: { duration: 0.25, ease: [0.22, 1, 0.36, 1] } }
  };

  const staggerContainer = {
    animate: { transition: { staggerChildren: 0.08 } }
  };

  const cardVariants = {
    initial: { opacity: 0, y: 15 },
    animate: { opacity: 1, y: 0, transition: { duration: 0.4, ease: [0.22, 1, 0.36, 1] } }
  };

  // Workspace Switcher Data
  const workspaces = [
    { id: 'CLIENT' as Role, name: 'Personal', desc: 'Buy & track orders', icon: User, color: 'text-blue-600', bg: 'bg-blue-50' },
    { id: 'SHOPPER' as Role, name: 'Shopper', desc: 'Manage quotes & purchases', icon: ShoppingBag, color: 'text-purple-600', bg: 'bg-purple-50' },
    { id: 'LOGISTICS' as Role, name: 'Logistics Hub', desc: 'Warehouse & transit', icon: Truck, color: 'text-orange-600', bg: 'bg-orange-50' },
    { id: 'ADMIN' as Role, name: 'Admin Console', desc: 'Platform overview', icon: Shield, color: 'text-zinc-800', bg: 'bg-zinc-100' },
  ];
  const activeWorkspace = workspaces.find(w => w.id === role)!;

  // --- Sub-views ---
  const AccountSettings = () => {
    const settingsNav = [
      { id: 'PROFILE' as const, label: 'Profile', desc: 'Name and email', icon: User },
      { id: 'SECURITY' as const, label: 'Security', desc: 'Password and access', icon: Lock },
      { id: 'MONEY' as const, label: 'Mobile Money', desc: 'Payment phones', icon: Smartphone },
      { id: 'ADDRESSES' as const, label: 'Addresses', desc: 'Shipping and sender', icon: MapPin },
    ];

    const addressCards = [
      { label: 'Default delivery', name: 'Jean Rakoto', line: 'Lot II M 42 Bis, Antsakaviro', city: 'Antananarivo 101', phone: '+261 34 00 000 00', tag: 'Home' },
      { label: 'Sender / pickup', name: 'MadaShopper Hub', line: 'Ivandry Business Center', city: 'Antananarivo 101', phone: '+261 32 11 222 33', tag: 'Office' },
    ];

    const moneyAccounts = [
      { name: 'MVola', phone: userProfile.phone, tone: 'bg-red-50 text-red-700 border-red-100', primary: true },
      { name: 'Orange Money', phone: '+261 32 00 000 00', tone: 'bg-orange-50 text-orange-700 border-orange-100', primary: false },
      { name: 'Airtel Money', phone: '+261 33 00 000 00', tone: 'bg-rose-50 text-rose-700 border-rose-100', primary: false },
    ];

    const Field = ({ label, children }: { label: string; children: React.ReactNode }) => (
      <div className="space-y-2">
        <label className="block text-[13px] font-semibold text-zinc-500 ml-1">{label}</label>
        {children}
      </div>
    );

    const inputClass = "w-full bg-[#F6F6F7] border border-transparent rounded-[16px] p-3.5 text-[15px] text-black outline-none placeholder:text-zinc-400 focus:bg-white focus:border-black/[0.08] focus:ring-4 focus:ring-black/[0.06] transition-all";

    return (
      <motion.div variants={pageVariants} initial="initial" animate="animate" exit="exit" className="max-w-6xl mx-auto">
        <button onClick={() => setView('LIST')} className="flex items-center gap-2 text-zinc-500 hover:text-black transition-colors mb-4 text-[14px] font-medium">
          <ArrowLeft size={18} /> Back to Dashboard
        </button>

        <div className="mb-5 flex flex-col lg:flex-row lg:items-end justify-between gap-4">
          <div>
            <div className="text-[12px] font-semibold tracking-[0.18em] uppercase text-zinc-400 mb-2">Account center</div>
            <h2 className="text-[30px] sm:text-[38px] font-semibold text-black leading-[1.05]">Settings that stay out of your way.</h2>
            <p className="text-zinc-500 text-[15px] mt-2 max-w-2xl">Keep identity, payment phones, and delivery details organized in one calm place across every workspace.</p>
          </div>
          <div className="hidden sm:flex items-center gap-3 rounded-[22px] bg-white border border-black/[0.05] p-3 shadow-[0_12px_36px_-20px_rgba(0,0,0,0.25)]">
            <div className="w-11 h-11 rounded-full bg-black text-white flex items-center justify-center font-semibold">{userProfile.firstName[0]}{userProfile.lastName[0]}</div>
            <div className="pr-2">
              <div className="text-[15px] font-semibold text-black">{userProfile.firstName} {userProfile.lastName}</div>
              <div className="text-[13px] text-zinc-500">4 workspaces connected</div>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-[280px_1fr] gap-5 items-start">
          <aside className="bg-white/80 backdrop-blur-xl rounded-[26px] border border-black/[0.06] p-2 shadow-[0_18px_50px_-30px_rgba(0,0,0,0.28)] lg:sticky lg:top-[92px]">
            <div className="lg:hidden px-3 py-2 text-[12px] font-semibold text-zinc-400 uppercase tracking-wider">Settings menu</div>
            {settingsNav.map((item) => (
              <button key={item.id} onClick={() => setAccountSection(item.id)} className={`w-full group flex items-center gap-3 p-2.5 rounded-[18px] transition-all ${accountSection === item.id ? 'bg-black text-white shadow-[0_10px_26px_-18px_rgba(0,0,0,0.8)]' : 'text-zinc-700 hover:bg-black/[0.035]'}`}>
                <div className={`w-9 h-9 rounded-[13px] flex items-center justify-center border transition-colors ${accountSection === item.id ? 'bg-white/12 border-white/15 text-white' : 'bg-zinc-50 border-black/[0.04] text-zinc-500 group-hover:text-black'}`}>
                  <item.icon size={18} />
                </div>
                <div className="text-left flex-1">
                  <div className="text-[15px] font-semibold leading-tight">{item.label}</div>
                  <div className={`text-[12px] mt-0.5 ${accountSection === item.id ? 'text-white/60' : 'text-zinc-400'}`}>{item.desc}</div>
                </div>
                <ChevronRight size={16} className={accountSection === item.id ? 'opacity-80' : 'opacity-25'} />
              </button>
            ))}
          </aside>

          <section className="bg-white rounded-[30px] border border-black/[0.06] shadow-[0_18px_60px_-34px_rgba(0,0,0,0.35)] overflow-hidden lg:min-h-[520px]">
            <AnimatePresence mode="wait">
              {accountSection === 'PROFILE' && (
                <motion.div key="profile" variants={pageVariants} initial="initial" animate="animate" exit="exit" className="p-5 sm:p-7">
                  <div className="mb-5"><h3 className="text-[24px] font-semibold text-black">Profile</h3><p className="text-zinc-500 mt-1">This identity appears on orders, quotes, and delivery handoffs.</p></div>
                  <form onSubmit={handleUpdateProfile} className="space-y-4">
                    <div className="grid sm:grid-cols-2 gap-5"><Field label="First name"><input required name="firstName" defaultValue={userProfile.firstName} className={inputClass} /></Field><Field label="Last name"><input required name="lastName" defaultValue={userProfile.lastName} className={inputClass} /></Field></div>
                    <Field label="Email address"><input required name="email" type="email" defaultValue={userProfile.email} className={inputClass} /></Field>
                    <Field label="Primary phone"><input required name="phone" type="tel" defaultValue={userProfile.phone} className={inputClass} /></Field>
                    <button type="submit" className="bg-black text-white px-6 py-3 rounded-[16px] text-[15px] font-medium hover:bg-zinc-800 transition-colors">Save profile</button>
                  </form>
                </motion.div>
              )}

              {accountSection === 'SECURITY' && (
                <motion.div key="security" variants={pageVariants} initial="initial" animate="animate" exit="exit" className="p-5 sm:p-7">
                  <div className="mb-5"><h3 className="text-[24px] font-semibold text-black">Password & security</h3><p className="text-zinc-500 mt-1">Simple controls for protecting high-value purchase requests.</p></div>
                  <form onSubmit={handleUpdatePassword} className="space-y-4 max-w-2xl"><Field label="Current password"><input required name="currentPassword" type="password" placeholder="••••••••" className={inputClass} /></Field><div className="grid sm:grid-cols-2 gap-5"><Field label="New password"><input required name="newPassword" type="password" placeholder="••••••••" className={inputClass} /></Field><Field label="Confirm password"><input required name="confirmPassword" type="password" placeholder="••••••••" className={inputClass} /></Field></div><div className="rounded-[22px] bg-zinc-50 border border-black/[0.04] p-4 flex gap-3 text-[14px] text-zinc-600"><Shield size={18} className="text-zinc-400 shrink-0 mt-0.5" /> Two-step verification will use your primary Mobile Money phone for sensitive actions.</div><button type="submit" className="bg-black text-white px-6 py-3 rounded-[16px] text-[15px] font-medium hover:bg-zinc-800 transition-colors">Update password</button></form>
                </motion.div>
              )}

              {accountSection === 'MONEY' && (
                <motion.div key="money" variants={pageVariants} initial="initial" animate="animate" exit="exit" className="p-5 sm:p-7">
                  <div className="mb-5"><h3 className="text-[24px] font-semibold text-black">Mobile Money</h3><p className="text-zinc-500 mt-1">Choose which number receives payment prompts for MVola, Orange Money, and Airtel Money.</p></div>
                  <div className="grid gap-4">{moneyAccounts.map((account) => (<div key={account.name} className="rounded-[24px] border border-black/[0.06] p-5 flex flex-col sm:flex-row sm:items-center justify-between gap-4 hover:bg-zinc-50/70 transition-colors"><div className="flex items-center gap-4"><div className={`px-3 py-1.5 rounded-full border text-[12px] font-semibold ${account.tone}`}>{account.name}</div><div><div className="font-semibold text-black">{account.phone}</div><div className="text-[13px] text-zinc-500">{account.primary ? 'Primary checkout number' : 'Backup payment route'}</div></div></div><button className="text-[14px] font-semibold text-black bg-zinc-100 hover:bg-zinc-200 px-4 py-2 rounded-[14px] transition-colors">Edit</button></div>))}</div>
                </motion.div>
              )}

              {accountSection === 'ADDRESSES' && (
                <motion.div key="addresses" variants={pageVariants} initial="initial" animate="animate" exit="exit" className="p-5 sm:p-7">
                  <div className="mb-5 flex flex-col sm:flex-row sm:items-start justify-between gap-4"><div><h3 className="text-[26px] font-semibold text-black">Addresses</h3><p className="text-zinc-500 mt-1">Separate where we deliver locally from sender and pickup references.</p></div><button className="bg-black text-white px-5 py-3 rounded-[16px] text-[14px] font-medium hover:bg-zinc-800 transition-colors flex items-center gap-2"><Plus size={17} /> Add address</button></div>
                  <div className="grid md:grid-cols-2 gap-4 mb-5">{addressCards.map((address) => (<div key={address.label} className="rounded-[26px] border border-black/[0.06] p-5 bg-white hover:shadow-[0_14px_36px_-26px_rgba(0,0,0,0.45)] transition-all"><div className="flex items-center justify-between mb-5"><span className="text-[12px] font-semibold tracking-[0.14em] uppercase text-zinc-400">{address.label}</span><span className="text-[12px] font-semibold bg-zinc-100 text-zinc-700 px-2.5 py-1 rounded-full">{address.tag}</span></div><div className="font-semibold text-black">{address.name}</div><div className="text-[14px] text-zinc-500 mt-2 leading-relaxed">{address.line}<br />{address.city}<br />{address.phone}</div><div className="mt-5 flex gap-2"><button className="text-[14px] font-semibold bg-zinc-100 hover:bg-zinc-200 px-4 py-2 rounded-[14px] transition-colors">Edit</button><button className="text-[14px] font-semibold text-zinc-500 hover:text-black px-4 py-2 rounded-[14px] transition-colors">Make default</button></div></div>))}</div>
                  <div className="rounded-[24px] bg-[#F7F4EF] border border-black/[0.04] p-5 flex gap-4"><Truck className="text-zinc-500 shrink-0" size={22} /><div><div className="font-semibold text-black">Delivery preference</div><div className="text-[14px] text-zinc-600 mt-1">Local dispatch defaults to Antananarivo courier. Regional delivery can be confirmed before payment on each quote.</div></div></div>
                </motion.div>
              )}
            </AnimatePresence>
          </section>
        </div>
      </motion.div>
    );
  };

  const ClientDashboard = () => {
    // Separate requests requiring action
    const actionRequired = requests.filter(r => r.status === 'QUOTE_AVAILABLE');
    const otherRequests = requests.filter(r => r.status !== 'QUOTE_AVAILABLE');

    return (
      <motion.div variants={pageVariants} initial="initial" animate="animate" exit="exit" className="space-y-12 max-w-4xl mx-auto">
        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-end gap-6 pb-2">
          <div>
            <h2 className="text-[36px] font-semibold tracking-tight text-black leading-tight">Your Orders</h2>
            <p className="text-zinc-500 text-[17px] mt-1">Track your international purchases effortlessly.</p>
          </div>
          <motion.button 
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            onClick={() => setView('NEW_REQUEST')}
            className="flex items-center justify-center gap-2 bg-black text-white px-6 py-3.5 rounded-[18px] font-medium transition-colors shadow-sm hover:shadow-md w-full sm:w-auto"
          >
            <Plus size={18} strokeWidth={2.5} /> <span>New Request</span>
          </motion.button>
        </div>

        <motion.div variants={staggerContainer} initial="initial" animate="animate" className="space-y-8">
          
          {actionRequired.length > 0 && (
            <div className="space-y-4">
              <h3 className="text-[15px] font-semibold text-zinc-900 tracking-wide uppercase px-1">Needs Your Attention</h3>
              {actionRequired.map(req => (
                <motion.div 
                  variants={cardVariants}
                  key={req.id} 
                  className="group relative bg-white rounded-[28px] p-5 sm:p-6 flex flex-col sm:flex-row gap-5 sm:gap-6 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.06)] border border-blue-100 transition-all hover:shadow-[0_8px_30px_-8px_rgba(0,0,0,0.12)]"
                >
                  <div className="w-full sm:w-[120px] aspect-square rounded-[18px] bg-zinc-50 overflow-hidden shrink-0 border border-black/[0.03] flex items-center justify-center">
                    {req.imageUrl ? (
                      <img src={req.imageUrl} alt={req.title} className="w-full h-full object-cover" />
                    ) : (
                      <ImageIcon className="text-zinc-300" size={32} />
                    )}
                  </div>
                  
                  <div className="flex-1 flex flex-col justify-center">
                    <div className="flex items-center gap-3 mb-2">
                      <span className="text-[12px] font-semibold text-zinc-400 tracking-wider uppercase">{req.id}</span>
                      <StatusBadge status={req.status} />
                    </div>
                    <h3 className="text-[20px] font-medium text-black leading-snug line-clamp-2 mb-1">{req.title}</h3>
                    <a href={req.url} target="_blank" rel="noreferrer" className="text-[15px] text-zinc-500 hover:text-black transition-colors truncate max-w-md flex items-center gap-1.5">
                      <span className="truncate">{req.url}</span>
                      <ChevronRight size={14} className="opacity-50" />
                    </a>
                  </div>

                  <div className="flex flex-row sm:flex-col items-center sm:items-end justify-between sm:justify-center gap-4 shrink-0 mt-2 sm:mt-0 pt-4 sm:pt-0 border-t border-black/[0.04] sm:border-t-0">
                    <div className="text-left sm:text-right">
                      <div className="text-[13px] font-medium text-zinc-500 mb-0.5">Quote Total</div>
                      <div className="text-2xl font-semibold text-black tracking-tight">{req.quote?.totalMGA.toLocaleString()} <span className="text-sm font-medium text-zinc-400">MGA</span></div>
                    </div>
                    <motion.button 
                      whileHover={{ scale: 1.02 }}
                      whileTap={{ scale: 0.98 }}
                      onClick={() => { setActiveRequest(req); setView('QUOTE_REVIEW'); }}
                      className="bg-blue-600 text-white px-5 py-2.5 rounded-[14px] text-[15px] font-medium hover:bg-blue-700 transition-colors shadow-sm"
                    >
                      Review & Pay
                    </motion.button>
                  </div>
                </motion.div>
              ))}
            </div>
          )}

          <div className="space-y-4">
            {actionRequired.length > 0 && <h3 className="text-[15px] font-semibold text-zinc-900 tracking-wide uppercase px-1 mt-4">Active & Past Orders</h3>}
            {otherRequests.map(req => (
              <motion.div 
                variants={cardVariants}
                key={req.id} 
                className="group relative bg-white rounded-[28px] p-5 sm:p-6 flex flex-col sm:flex-row gap-5 sm:gap-6 shadow-[0_2px_12px_-4px_rgba(0,0,0,0.03)] border border-black/[0.04] transition-all hover:shadow-[0_8px_24px_-8px_rgba(0,0,0,0.06)]"
              >
                <div className="w-full sm:w-[120px] aspect-square rounded-[18px] bg-zinc-50 overflow-hidden shrink-0 border border-black/[0.03] flex items-center justify-center">
                  {req.imageUrl ? (
                    <img src={req.imageUrl} alt={req.title} className="w-full h-full object-cover" />
                  ) : (
                    <ImageIcon className="text-zinc-300" size={32} />
                  )}
                </div>
                
                <div className="flex-1 flex flex-col justify-center">
                  <div className="flex items-center gap-3 mb-2">
                    <span className="text-[12px] font-semibold text-zinc-400 tracking-wider uppercase">{req.id}</span>
                    <StatusBadge status={req.status} />
                  </div>
                  <h3 className="text-[20px] font-medium text-black leading-snug line-clamp-2 mb-1">{req.title}</h3>
                  <a href={req.url} target="_blank" rel="noreferrer" className="text-[15px] text-zinc-500 hover:text-black transition-colors truncate max-w-md flex items-center gap-1.5">
                    <span className="truncate">{req.url}</span>
                    <ChevronRight size={14} className="opacity-50" />
                  </a>
                  
                  {/* Premium Tracking Bar for Active Items */}
                  <TrackingProgress status={req.status} />
                </div>

                <div className="flex items-center sm:items-end justify-between sm:justify-center shrink-0 mt-2 sm:mt-0 pt-4 sm:pt-0 border-t border-black/[0.04] sm:border-t-0">
                  {req.status === 'SUBMITTED' ? (
                     <div className="text-[14px] text-zinc-400 font-medium flex items-center gap-2 bg-zinc-50 px-4 py-2 rounded-xl">
                       <Clock size={16} /> Awaiting Quote
                     </div>
                  ) : (
                    <div className="text-left sm:text-right">
                      <div className="text-[13px] font-medium text-zinc-500 mb-0.5">Total Paid</div>
                      <div className="text-xl font-semibold text-black tracking-tight">{req.quote?.totalMGA.toLocaleString()} <span className="text-sm font-medium text-zinc-400">MGA</span></div>
                    </div>
                  )}
                </div>
              </motion.div>
            ))}
          </div>

        </motion.div>
      </motion.div>
    );
  };

  const ShopperDashboard = () => (
    <motion.div variants={pageVariants} initial="initial" animate="animate" exit="exit" className="space-y-10 max-w-3xl mx-auto">
      <div className="pb-2">
        <h2 className="text-[32px] font-semibold tracking-tight text-black leading-tight">Shopper Tasks</h2>
        <p className="text-zinc-500 text-lg mt-1">Manage pending requests and active orders.</p>
      </div>

      <motion.div variants={staggerContainer} initial="initial" animate="animate" className="grid gap-5">
        {requests.map(req => (
          <motion.div 
            variants={cardVariants}
            key={req.id} 
            className="group relative bg-white rounded-[24px] p-6 sm:p-8 flex flex-col sm:flex-row sm:items-center justify-between shadow-[0_2px_12px_-4px_rgba(0,0,0,0.04)] border border-black/[0.04] transition-all hover:shadow-[0_8px_24px_-8px_rgba(0,0,0,0.08)]"
          >
            <div className="space-y-3 mb-6 sm:mb-0">
              <div className="flex items-center gap-3">
                <span className="text-[13px] font-semibold text-zinc-400 tracking-wider uppercase">{req.id}</span>
                <StatusBadge status={req.status} />
              </div>
              <h3 className="text-[19px] font-medium text-black leading-snug max-w-md line-clamp-2">{req.title}</h3>
              <a href={req.url} target="_blank" rel="noreferrer" className="text-[15px] text-zinc-500 hover:text-black transition-colors truncate block max-w-md flex items-center gap-1.5">
                <span className="truncate">{req.url}</span>
                <ChevronRight size={14} className="opacity-50" />
              </a>
            </div>

            <div className="flex items-center sm:justify-end gap-3 shrink-0 w-full sm:w-auto mt-2 sm:mt-0">
              {req.status === 'SUBMITTED' && (
                <motion.button 
                  whileHover={{ scale: 1.02 }}
                  whileTap={{ scale: 0.98 }}
                  onClick={() => { setActiveRequest(req); setView('QUOTE_CREATE'); }}
                  className="w-full sm:w-auto bg-black text-white px-6 py-3 rounded-2xl text-[15px] font-medium hover:bg-zinc-800 transition-colors"
                >
                  Create Quote
                </motion.button>
              )}
              {req.status === 'PAID' && (
                <motion.button 
                  whileHover={{ scale: 1.02 }}
                  whileTap={{ scale: 0.98 }}
                  onClick={() => updateStatus(req.id, 'PURCHASED')}
                  className="w-full sm:w-auto bg-zinc-100 text-black px-6 py-3 rounded-2xl text-[15px] font-medium hover:bg-zinc-200 transition-colors"
                >
                  Mark Purchased
                </motion.button>
              )}
            </div>
          </motion.div>
        ))}
      </motion.div>
    </motion.div>
  );

  const LogisticsDashboard = () => {
    const activeParcels = requests.filter(r => ['PURCHASED', 'WAREHOUSE_RECEIVED', 'INTERNATIONAL_TRANSIT', 'ARRIVED_IN_MADAGASCAR'].includes(r.status));

    return (
      <motion.div variants={pageVariants} initial="initial" animate="animate" exit="exit" className="space-y-10 max-w-3xl mx-auto">
        <div className="pb-2">
          <h2 className="text-[32px] font-semibold tracking-tight text-black leading-tight">Logistics Hub</h2>
          <p className="text-zinc-500 text-lg mt-1">Manage receiving, shipping, and delivery.</p>
        </div>

        <motion.div variants={staggerContainer} initial="initial" animate="animate" className="grid gap-5">
          {activeParcels.map(req => (
            <motion.div 
              variants={cardVariants}
              key={req.id} 
              className="group relative bg-white rounded-[24px] p-6 sm:p-8 flex flex-col sm:flex-row sm:items-center justify-between shadow-[0_2px_12px_-4px_rgba(0,0,0,0.04)] border border-black/[0.04] transition-all hover:shadow-[0_8px_24px_-8px_rgba(0,0,0,0.08)]"
            >
              <div className="space-y-3 mb-6 sm:mb-0">
                <div className="flex items-center gap-3">
                  <span className="text-[13px] font-semibold text-zinc-400 tracking-wider uppercase">{req.id}</span>
                  <StatusBadge status={req.status} />
                </div>
                <h3 className="text-[19px] font-medium text-black leading-snug max-w-md line-clamp-2">{req.title}</h3>
                <div className="text-[15px] text-zinc-500">Destination: Antananarivo, Madagascar</div>
              </div>

              <div className="flex items-center sm:justify-end gap-3 shrink-0 w-full sm:w-auto mt-2 sm:mt-0">
                {req.status === 'PURCHASED' && (
                  <motion.button 
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                    onClick={() => updateStatus(req.id, 'WAREHOUSE_RECEIVED')}
                    className="w-full sm:w-auto bg-black text-white px-6 py-3 rounded-2xl text-[15px] font-medium hover:bg-zinc-800 transition-colors flex gap-2 items-center justify-center"
                  >
                    <Box size={18}/> Receive Box
                  </motion.button>
                )}
                {req.status === 'WAREHOUSE_RECEIVED' && (
                  <motion.button 
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                    onClick={() => updateStatus(req.id, 'INTERNATIONAL_TRANSIT')}
                    className="w-full sm:w-auto bg-black text-white px-6 py-3 rounded-2xl text-[15px] font-medium hover:bg-zinc-800 transition-colors flex gap-2 items-center justify-center"
                  >
                    <Truck size={18}/> Ship to Mada
                  </motion.button>
                )}
                {req.status === 'INTERNATIONAL_TRANSIT' && (
                  <motion.button 
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                    onClick={() => updateStatus(req.id, 'ARRIVED_IN_MADAGASCAR')}
                    className="w-full sm:w-auto bg-black text-white px-6 py-3 rounded-2xl text-[15px] font-medium hover:bg-zinc-800 transition-colors flex gap-2 items-center justify-center"
                  >
                    <MapPin size={18}/> Arrived Mada
                  </motion.button>
                )}
                {req.status === 'ARRIVED_IN_MADAGASCAR' && (
                  <motion.button 
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                    onClick={() => updateStatus(req.id, 'DELIVERED')}
                    className="w-full sm:w-auto bg-green-600 text-white px-6 py-3 rounded-2xl text-[15px] font-medium hover:bg-green-700 transition-colors flex gap-2 items-center justify-center"
                  >
                    <Check size={18}/> Mark Delivered
                  </motion.button>
                )}
              </div>
            </motion.div>
          ))}
          {activeParcels.length === 0 && (
             <div className="text-zinc-500 py-10 text-center text-lg">No active logistics tasks.</div>
          )}
        </motion.div>
      </motion.div>
    );
  };

  const AdminDashboard = () => (
    <motion.div variants={pageVariants} initial="initial" animate="animate" exit="exit" className="space-y-10 max-w-4xl mx-auto">
      <div className="pb-2 border-b border-black/[0.04]">
        <h2 className="text-[32px] font-semibold tracking-tight text-black leading-tight">Admin Overview</h2>
        <p className="text-zinc-500 text-lg mt-1">Platform metrics and global requests.</p>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-3 gap-5">
        <div className="bg-white rounded-[24px] p-6 shadow-[0_2px_12px_-4px_rgba(0,0,0,0.04)] border border-black/[0.04]">
          <div className="flex items-center gap-3 text-zinc-500 mb-3"><FileText size={20}/> Total Requests</div>
          <div className="text-3xl font-semibold tracking-tight text-black">{requests.length}</div>
        </div>
        <div className="bg-white rounded-[24px] p-6 shadow-[0_2px_12px_-4px_rgba(0,0,0,0.04)] border border-black/[0.04]">
          <div className="flex items-center gap-3 text-zinc-500 mb-3"><TrendingUp size={20}/> Delivered</div>
          <div className="text-3xl font-semibold tracking-tight text-black">{requests.filter(r => r.status === 'DELIVERED').length}</div>
        </div>
        <div className="bg-white rounded-[24px] p-6 shadow-[0_2px_12px_-4px_rgba(0,0,0,0.04)] border border-black/[0.04]">
          <div className="flex items-center gap-3 text-zinc-500 mb-3"><Users size={20}/> Active Users</div>
          <div className="text-3xl font-semibold tracking-tight text-black">12</div>
        </div>
      </div>

      <div>
        <h3 className="text-[20px] font-semibold tracking-tight text-black mb-5">All Platform Requests</h3>
        <motion.div variants={staggerContainer} initial="initial" animate="animate" className="grid gap-4">
          {requests.map(req => (
            <motion.div 
              variants={cardVariants}
              key={req.id} 
              className="bg-white rounded-[20px] p-5 flex items-center justify-between shadow-[0_2px_12px_-4px_rgba(0,0,0,0.04)] border border-black/[0.04]"
            >
              <div className="space-y-1">
                <div className="flex items-center gap-3">
                  <span className="text-[12px] font-semibold text-zinc-400 tracking-wider uppercase">{req.id}</span>
                  <StatusBadge status={req.status} />
                </div>
                <h3 className="text-[16px] font-medium text-black leading-snug">{req.title}</h3>
              </div>
              <div className="text-right">
                {req.quote ? (
                  <div className="text-[14px] font-medium text-black">{req.quote.totalMGA.toLocaleString()} MGA</div>
                ) : (
                  <div className="text-[14px] text-zinc-400">No quote yet</div>
                )}
              </div>
            </motion.div>
          ))}
        </motion.div>
      </div>
    </motion.div>
  );

  const NewRequestForm = () => (
    <motion.div variants={pageVariants} initial="initial" animate="animate" exit="exit" className="max-w-2xl mx-auto">
      <button onClick={() => setView('LIST')} className="flex items-center gap-2 text-zinc-500 hover:text-black transition-colors mb-8 text-[15px] font-medium">
        <ArrowLeft size={18} /> Back to Requests
      </button>
      
      <div className="bg-white rounded-[32px] p-8 sm:p-12 shadow-[0_8px_32px_-12px_rgba(0,0,0,0.06)] border border-black/[0.04]">
        <h2 className="text-[28px] font-semibold tracking-tight text-black mb-8">What would you like to buy?</h2>
        <form onSubmit={handleCreateRequest} className="space-y-6">
          <div className="space-y-1.5">
            <label className="block text-[15px] font-medium text-zinc-900 ml-1">Product Name</label>
            <input 
              required 
              name="title" 
              type="text" 
              placeholder="e.g. Sony WH-1000XM5" 
              className="w-full bg-zinc-50 border-transparent rounded-[20px] p-4 text-[17px] text-black outline-none placeholder:text-zinc-400 focus:bg-white focus:ring-2 focus:ring-black transition-all" 
            />
          </div>
          <div className="space-y-1.5">
            <label className="block text-[15px] font-medium text-zinc-900 ml-1">Product Link (URL)</label>
            <input 
              required 
              name="url" 
              type="url" 
              placeholder="https://..." 
              className="w-full bg-zinc-50 border-transparent rounded-[20px] p-4 text-[17px] text-black outline-none placeholder:text-zinc-400 focus:bg-white focus:ring-2 focus:ring-black transition-all" 
            />
          </div>
          <div className="space-y-1.5">
            <label className="block text-[15px] font-medium text-zinc-900 ml-1">Max Budget (Optional, EUR/USD)</label>
            <input 
              name="budget" 
              type="number" 
              placeholder="0.00" 
              className="w-full bg-zinc-50 border-transparent rounded-[20px] p-4 text-[17px] text-black outline-none placeholder:text-zinc-400 focus:bg-white focus:ring-2 focus:ring-black transition-all" 
            />
          </div>
          <div className="pt-6">
            <motion.button 
              whileHover={{ scale: 1.01 }}
              whileTap={{ scale: 0.99 }}
              type="submit" 
              className="w-full bg-black text-white px-6 py-4 rounded-[20px] text-[17px] font-medium hover:bg-zinc-800 transition-colors shadow-md"
            >
              Submit Request
            </motion.button>
          </div>
        </form>
      </div>
    </motion.div>
  );

  const QuoteReview = () => {
    if (!activeRequest?.quote) return null;
    return (
      <motion.div variants={pageVariants} initial="initial" animate="animate" exit="exit" className="max-w-2xl mx-auto">
        <button onClick={() => setView('LIST')} className="flex items-center gap-2 text-zinc-500 hover:text-black transition-colors mb-8 text-[15px] font-medium">
          <ArrowLeft size={18} /> Back to Requests
        </button>

        <div className="bg-white rounded-[32px] p-8 sm:p-12 shadow-[0_8px_32px_-12px_rgba(0,0,0,0.06)] border border-black/[0.04]">
          <h2 className="text-[28px] font-semibold tracking-tight text-black mb-2">Quote Details</h2>
          <p className="text-zinc-500 text-[17px] mb-8 leading-snug">{activeRequest.title}</p>
          
          <div className="bg-[#FBFBFD] rounded-[24px] p-6 sm:p-8 mb-8 space-y-4 text-[15px] border border-black/[0.03]">
            <div className="flex justify-between items-center">
              <span className="text-zinc-500">Product Cost</span>
              <span className="font-medium text-black">€ {activeRequest.quote.productAmount.toLocaleString()}</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-zinc-500">Exchange Rate</span>
              <span className="font-medium text-black">1 € = {activeRequest.quote.exchangeRate} MGA</span>
            </div>
            <div className="border-t border-black/[0.08] pt-4 flex justify-between items-center">
              <span className="text-zinc-500">Converted Cost</span>
              <span className="font-medium text-black">{(activeRequest.quote.productAmount * activeRequest.quote.exchangeRate).toLocaleString()} MGA</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-zinc-500">Service Fee</span>
              <span className="font-medium text-black">{activeRequest.quote.serviceFee.toLocaleString()} MGA</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-zinc-500">Local Delivery</span>
              <span className="font-medium text-black">{activeRequest.quote.localDeliveryFee.toLocaleString()} MGA</span>
            </div>
            <div className="border-t border-black/[0.08] pt-5 mt-2 flex justify-between items-center">
              <span className="text-lg text-black font-semibold">Total to Pay</span>
              <span className="text-2xl text-black font-semibold tracking-tight">{activeRequest.quote.totalMGA.toLocaleString()} MGA</span>
            </div>
          </div>

          <div className="flex flex-col sm:flex-row gap-4">
            <motion.button 
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              onClick={() => handleAcceptQuote(activeRequest)} 
              className="bg-black text-white px-6 py-4 rounded-[20px] text-[17px] font-medium hover:bg-zinc-800 transition-colors shadow-md flex-1 flex justify-center items-center gap-2"
            >
              Accept & Pay <ArrowRight size={20} />
            </motion.button>
            <motion.button 
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              onClick={() => setView('LIST')} 
              className="bg-zinc-100 text-black px-6 py-4 rounded-[20px] text-[17px] font-medium hover:bg-zinc-200 transition-colors sm:w-auto w-full"
            >
              Decline
            </motion.button>
          </div>
        </div>
      </motion.div>
    );
  };

  const PaymentSimulation = () => {
    if (!activeRequest?.quote) return null;
    return (
      <motion.div variants={pageVariants} initial="initial" animate="animate" exit="exit" className="max-w-xl mx-auto">
        <button onClick={() => setView('LIST')} className="flex items-center gap-2 text-zinc-500 hover:text-black transition-colors mb-8 text-[15px] font-medium">
          <ArrowLeft size={18} /> Cancel Payment
        </button>

        <div className="bg-white rounded-[32px] p-8 sm:p-12 shadow-[0_8px_32px_-12px_rgba(0,0,0,0.06)] border border-black/[0.04]">
          <div className="text-center mb-10">
            <h2 className="text-[28px] font-semibold tracking-tight text-black mb-3">Complete Payment</h2>
            <div className="text-4xl font-semibold tracking-tighter text-black">{activeRequest.quote.totalMGA.toLocaleString()} <span className="text-2xl text-zinc-400">MGA</span></div>
          </div>
          
          <div className="space-y-4 mb-10">
            <label className="group relative flex items-center gap-4 p-5 rounded-[24px] cursor-pointer bg-white border-2 border-black transition-all">
              <input type="radio" name="operator" defaultChecked className="peer sr-only" />
              <div className="w-6 h-6 rounded-full border-2 border-zinc-300 peer-checked:border-[7px] peer-checked:border-black transition-all"></div>
              <span className="text-[17px] font-medium text-black">MVola</span>
            </label>
            <label className="group relative flex items-center gap-4 p-5 rounded-[24px] cursor-pointer bg-white border-2 border-transparent hover:border-black/[0.08] transition-all bg-zinc-50 hover:bg-zinc-100">
              <input type="radio" name="operator" className="peer sr-only" />
              <div className="w-6 h-6 rounded-full border-2 border-zinc-300 peer-checked:border-[7px] peer-checked:border-black transition-all"></div>
              <span className="text-[17px] font-medium text-black">Orange Money</span>
            </label>
            <label className="group relative flex items-center gap-4 p-5 rounded-[24px] cursor-pointer bg-white border-2 border-transparent hover:border-black/[0.08] transition-all bg-zinc-50 hover:bg-zinc-100">
              <input type="radio" name="operator" className="peer sr-only" />
              <div className="w-6 h-6 rounded-full border-2 border-zinc-300 peer-checked:border-[7px] peer-checked:border-black transition-all"></div>
              <span className="text-[17px] font-medium text-black">Airtel Money</span>
            </label>
          </div>

          <motion.button 
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            onClick={handlePayment} 
            className="w-full bg-black text-white px-6 py-4 rounded-[20px] text-[17px] font-medium hover:bg-zinc-800 transition-colors shadow-md flex justify-center items-center gap-2"
          >
            <Smartphone size={20} /> Authorize Payment
          </motion.button>
        </div>
      </motion.div>
    );
  };

  const QuoteCreateForm = () => {
    if (!activeRequest) return null;
    return (
      <motion.div variants={pageVariants} initial="initial" animate="animate" exit="exit" className="max-w-2xl mx-auto">
        <button onClick={() => setView('LIST')} className="flex items-center gap-2 text-zinc-500 hover:text-black transition-colors mb-8 text-[15px] font-medium">
          <ArrowLeft size={18} /> Back
        </button>

        <div className="bg-white rounded-[32px] p-8 sm:p-12 shadow-[0_8px_32px_-12px_rgba(0,0,0,0.06)] border border-black/[0.04]">
          <h2 className="text-[28px] font-semibold tracking-tight text-black mb-8">Calculate Quote</h2>
          
          <div className="mb-8 p-6 bg-[#FBFBFD] border border-black/[0.04] rounded-[24px]">
            <span className="text-[13px] font-semibold text-zinc-400 tracking-wider uppercase mb-1 block">Request Details</span>
            <div className="text-[17px] font-medium text-black leading-snug mb-2">{activeRequest.title}</div>
            <a href={activeRequest.url} target="_blank" rel="noreferrer" className="text-[15px] text-zinc-500 hover:text-black transition-colors truncate block">
              {activeRequest.url}
            </a>
          </div>
          
          <form onSubmit={handleCreateQuote} className="space-y-6">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-5">
              <div className="space-y-1.5">
                <label className="block text-[15px] font-medium text-zinc-900 ml-1">Product Amount (€/$)</label>
                <input required name="productAmount" type="number" defaultValue="0" className="w-full bg-zinc-50 border-transparent rounded-[20px] p-4 text-[17px] text-black outline-none focus:bg-white focus:ring-2 focus:ring-black transition-all" />
              </div>
              <div className="space-y-1.5">
                <label className="block text-[15px] font-medium text-zinc-900 ml-1">Exchange Rate (MGA)</label>
                <input required name="exchangeRate" type="number" defaultValue="4600" className="w-full bg-zinc-50 border-transparent rounded-[20px] p-4 text-[17px] text-black outline-none focus:bg-white focus:ring-2 focus:ring-black transition-all" />
              </div>
              <div className="space-y-1.5">
                <label className="block text-[15px] font-medium text-zinc-900 ml-1">Service Fee (MGA)</label>
                <input required name="serviceFee" type="number" defaultValue="50000" className="w-full bg-zinc-50 border-transparent rounded-[20px] p-4 text-[17px] text-black outline-none focus:bg-white focus:ring-2 focus:ring-black transition-all" />
              </div>
              <div className="space-y-1.5">
                <label className="block text-[15px] font-medium text-zinc-900 ml-1">Local Delivery (MGA)</label>
                <input required name="localDeliveryFee" type="number" defaultValue="15000" className="w-full bg-zinc-50 border-transparent rounded-[20px] p-4 text-[17px] text-black outline-none focus:bg-white focus:ring-2 focus:ring-black transition-all" />
              </div>
            </div>
            <div className="pt-6">
              <motion.button 
                whileHover={{ scale: 1.01 }}
                whileTap={{ scale: 0.99 }}
                type="submit" 
                className="w-full bg-black text-white px-6 py-4 rounded-[20px] text-[17px] font-medium hover:bg-zinc-800 transition-colors shadow-md"
              >
                Generate & Send Quote
              </motion.button>
            </div>
          </form>
        </div>
      </motion.div>
    );
  };

  return (
    <div className="min-h-screen bg-[#FBFBFD] font-sans selection:bg-black selection:text-white" style={{ fontFamily: "'Inter', sans-serif" }}>
      {/* Header */}
      <header className="sticky top-0 z-50 bg-white/70 backdrop-blur-xl border-b border-black/[0.04]">
        <div className="max-w-[1000px] mx-auto px-6 h-[80px] flex items-center justify-between">
          <div className="flex items-center gap-3 font-semibold text-[20px] tracking-tight text-black">
            <div className="bg-black text-white p-2 rounded-[12px] shadow-sm">
              <Package size={22} strokeWidth={2.5} />
            </div>
            MadaShopper
          </div>
          
          {/* Workspace Switcher & Profile - Premium Integrated Dropdown */}
          <div className="relative z-50">
            <button 
              onClick={() => setIsSwitcherOpen(!isSwitcherOpen)}
              className="flex items-center gap-3 hover:bg-black/[0.04] p-1.5 pr-3 rounded-[16px] transition-colors"
            >
              <div className={`w-9 h-9 rounded-full flex items-center justify-center border border-black/[0.05] shadow-sm ${activeWorkspace.bg} ${activeWorkspace.color}`}>
                <activeWorkspace.icon size={16} strokeWidth={2.5} />
              </div>
              <div className="text-left hidden sm:block mr-2">
                <div className="text-[14px] font-semibold text-black leading-tight">{activeWorkspace.name}</div>
                <div className="text-[12px] text-zinc-500 font-medium">{userProfile.firstName} {userProfile.lastName}</div>
              </div>
              <ChevronDown size={16} className={`text-zinc-400 transition-transform duration-200 ${isSwitcherOpen ? 'rotate-180' : ''}`} />
            </button>

            <AnimatePresence>
              {isSwitcherOpen && (
                <>
                  <div className="fixed inset-0 z-40" onClick={() => setIsSwitcherOpen(false)} />
                  <motion.div 
                    initial={{ opacity: 0, y: 8, scale: 0.96 }}
                    animate={{ opacity: 1, y: 0, scale: 1 }}
                    exit={{ opacity: 0, y: 8, scale: 0.96 }}
                    transition={{ duration: 0.2, ease: [0.16, 1, 0.3, 1] }}
                    className="absolute right-0 top-full mt-2 w-[320px] bg-white/95 backdrop-blur-2xl border border-black/[0.08] shadow-[0_24px_48px_-12px_rgba(0,0,0,0.18)] rounded-[24px] p-2 z-50 overflow-hidden"
                  >
                    {/* User Profile Summary Header */}
                    <div className="px-4 py-3 mb-2 flex items-center gap-3">
                      <div className="w-10 h-10 rounded-full bg-zinc-100 flex items-center justify-center text-zinc-600 font-semibold tracking-tight border border-black/[0.05]">
                        {userProfile.firstName[0]}{userProfile.lastName[0]}
                      </div>
                      <div className="flex-1 min-w-0">
                        <div className="text-[15px] font-semibold text-black truncate">{userProfile.firstName} {userProfile.lastName}</div>
                        <div className="text-[13px] text-zinc-500 truncate">{userProfile.email}</div>
                      </div>
                    </div>

                    <div className="h-px w-full bg-black/[0.06] mb-2" />

                    <div className="px-3 py-2 text-[12px] font-semibold text-zinc-400 uppercase tracking-wider mb-1">Switch Workspace</div>
                    <div className="space-y-1">
                      {workspaces.map((w) => (
                        <button
                          key={w.id}
                          onClick={() => {
                            setRole(w.id);
                            if (view === 'ACCOUNT_SETTINGS') setView('LIST');
                            setIsSwitcherOpen(false);
                          }}
                          className={`w-full flex items-center justify-between p-3 rounded-[16px] transition-colors ${role === w.id && view !== 'ACCOUNT_SETTINGS' ? 'bg-black/[0.04]' : 'hover:bg-black/[0.02]'}`}
                        >
                          <div className="flex items-center gap-3">
                            <div className={`w-9 h-9 rounded-full flex items-center justify-center border border-black/[0.05] ${w.bg} ${w.color}`}>
                              <w.icon size={16} strokeWidth={2.5} />
                            </div>
                            <div className="text-left">
                              <div className={`text-[14px] font-semibold leading-tight ${role === w.id && view !== 'ACCOUNT_SETTINGS' ? 'text-black' : 'text-zinc-700'}`}>{w.name}</div>
                            </div>
                          </div>
                          {role === w.id && view !== 'ACCOUNT_SETTINGS' && <CheckCircle2 size={18} className="text-black" />}
                        </button>
                      ))}
                    </div>

                    <div className="h-px w-full bg-black/[0.06] my-2" />
                    
                    {/* Account Actions */}
                    <div className="space-y-1">
                      <button
                        onClick={() => {
                          setView('ACCOUNT_SETTINGS');
                          setIsSwitcherOpen(false);
                        }}
                        className={`w-full flex items-center gap-3 p-3 rounded-[16px] transition-colors ${view === 'ACCOUNT_SETTINGS' ? 'bg-black/[0.04] text-black' : 'text-zinc-700 hover:bg-black/[0.02]'}`}
                      >
                        <Settings size={18} className="ml-1" />
                        <span className="text-[14px] font-semibold">Account Settings</span>
                      </button>
                      
                      <button
                        onClick={() => setIsSwitcherOpen(false)} // Mock sign out
                        className="w-full flex items-center gap-3 p-3 rounded-[16px] transition-colors text-red-600 hover:bg-red-50"
                      >
                        <LogOut size={18} className="ml-1" />
                        <span className="text-[14px] font-semibold">Sign Out</span>
                      </button>
                    </div>

                  </motion.div>
                </>
              )}
            </AnimatePresence>
          </div>

        </div>
      </header>

      {/* Main Content */}
      <main className="px-5 py-6 sm:py-8">
        <AnimatePresence mode="wait">
          {view === 'LIST' && (
            <motion.div key={`list-${role}`}>
              {role === 'CLIENT' && <ClientDashboard />}
              {role === 'SHOPPER' && <ShopperDashboard />}
              {role === 'LOGISTICS' && <LogisticsDashboard />}
              {role === 'ADMIN' && <AdminDashboard />}
            </motion.div>
          )}
          {view === 'NEW_REQUEST' && <NewRequestForm key="new-request" />}
          {view === 'QUOTE_REVIEW' && <QuoteReview key="quote-review" />}
          {view === 'PAYMENT' && <PaymentSimulation key="payment" />}
          {view === 'QUOTE_CREATE' && <QuoteCreateForm key="quote-create" />}
          {view === 'ACCOUNT_SETTINGS' && <AccountSettings key="account-settings" />}
        </AnimatePresence>
      </main>
    </div>
  );
}